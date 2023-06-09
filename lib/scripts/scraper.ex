defmodule FindYourFriendUniversity.Scraper do
  @moduledoc """
  This module provides functions for scraping data from DGES
  website and fill our database.
  """
  alias FindYourFriendUniversity.Universities
  alias FindYourFriendUniversity.Courses
  alias FindYourFriendUniversity.Finch, as: MyFinch

  @doc """
  Will scrape the DGES website and return all the data.

  ## Examples

      iex> FindYourFriendUniversity.Scraper.run())
      [
        {
          name: "Universidade do Minho",
          code: 1000,
          courses: [{
            name: "Engenharia Informática",
            code: 9119,
          }],
          ...
        },
        ...
      ]

  """
  def run do
    {:ok, %Finch.Response{body: body}} =
      Finch.build(:get, "https://www.dges.gov.pt/guias/indest.asp")
      |> Finch.request(MyFinch)

    {:ok, document} = Floki.parse_document(body)

    IO.inspect("Scraping all universities and courses.")

    courses_by_universities =
      document
      |> Floki.find("div")
      |> Enum.map(&row_parser/1)
      |> Enum.reject(&is_nil/1)
      |> organizer()

    IO.inspect("Storing Courses.")

    courses_by_universities
    |> Enum.reduce([], fn uni, courses_list -> courses_list ++ uni[:courses] end)
    |> Enum.uniq_by(fn %{id: id} -> id end)

    |> Courses.create_courses()

    IO.inspect("Storing Universities.")

    courses_by_universities
    |> Enum.map(fn uni ->
      uni
      |> Map.put(:courses_ids, uni[:courses] |> Enum.map(fn %{id: code_id} -> code_id end))
      |> Map.delete(:courses)
      |> IO.inspect()
    end)
    |> IO.inspect()

    |> Universities.create_universities()
  end

  defp row_parser({"div", [{"class", "box9"}], uni_row_html}) do
    uni_code =
      Floki.find(uni_row_html, ".lin-area-c1")
      |> Floki.text()

    uni_name =
      Floki.find(uni_row_html, ".lin-area-d2")
      |> Floki.text()
      |> :binary.bin_to_list()
      |> List.to_string()

    %{code: uni_code, name: uni_name, type: "university"}
  end

  defp row_parser({"div", [{"class", "lin-ce"}], course_row_html}) do
    course_code =
      Floki.find(course_row_html, ".lin-ce-c2")
      |> Floki.text()

    course_name =
      Floki.find(course_row_html, ".lin-ce-c3 a")
      |> Floki.text()
      |> :binary.bin_to_list()
      |> List.to_string()

    %{code: course_code, name: course_name, type: "course"}
  end

  defp row_parser(_) do
  end

  defp organizer([%{code: uni_code, name: uni_name, type: "university"} | tail]) do
    [current_uni | others_unis] = organizer(tail)

    [
      current_uni |> Map.put(:id, uni_code) |> Map.put(:name, uni_name)
      | others_unis
    ]
  end

  defp organizer([
         %{code: course_code, name: course_name, type: "course"},
         %{code: uni_code, name: uni_name, type: "university"} | tail
       ]) do
    [current_uni | others_unis] = organizer(tail)

    [
      %{courses: [%{id: course_code, name: course_name}]},
      current_uni |> Map.put(:id, uni_code) |> Map.put(:name, uni_name)
      | others_unis
    ]
  end

  defp organizer([%{code: course_code, name: course_name, type: "course"} | tail]) do
    case organizer(tail) do
      [%{courses: current_courses_group} | others_unis] ->
        [
          %{courses: [%{id: course_code, name: course_name} | current_courses_group]}
          | others_unis
        ]

      [] ->
        [%{courses: [%{id: course_code, name: course_name}]}]
    end
  end

  defp organizer([]) do
    []
  end
end
