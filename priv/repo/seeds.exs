# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     FindYourFriendUniversity.Repo.insert!(%FindYourFriendUniversity.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias FindYourFriendUniversity.Courses
alias FindYourFriendUniversity.Universities
alias FindYourFriendUniversity.Students
alias FindYourFriendUniversity.Applications

defmodule Seeds do
  def load_json_file_until_success([]), do: IO.puts("\nNo more files available to parse seeds.\n")

  def load_json_file_until_success([json_file_path | others_json_file_paths]) do
    IO.puts("\nTrying parse seeds from '#{json_file_path}'")

    case File.read(json_file_path) do
      {:ok, file_content} ->
        case Jason.decode(file_content) do
          {:ok, json_data} ->
            IO.puts("Success. Seeds parsed.\n")
            load_json(json_data)

          {:error, reason} ->
            IO.puts("Failed to parse JSON: #{reason}.")
            load_json_file_until_success(others_json_file_paths)
        end

      {:error, reason} ->
        IO.puts("Failed to read file: #{reason}.")
        load_json_file_until_success(others_json_file_paths)
    end
  end

  defp load_json(seeds) do
    courses =
      seeds
      |> Enum.reduce([], fn uni, courses_list -> courses_list ++ uni["courses"] end)
      |> Enum.uniq_by(fn course -> course |> Map.get("id") end)

    Courses.create_courses(courses)

    IO.inspect("Storing #{length(courses)} Courses from seeds")

    universities =
      seeds
      |> Enum.map(fn uni ->
        uni
        |> Map.put(
          "courses_ids",
          uni["courses"] |> Enum.map(fn course -> course |> Map.get("id") end)
        )
        |> Map.delete("courses")
      end)

    Universities.create_universities(universities)

    IO.inspect("Storing #{length(universities)} Universities from seeds")

    students =
      seeds
      |> Enum.map(fn uni ->
        uni["courses"]
        |> Enum.map(fn course ->
          course["applications"]
          |> Map.to_list()
          |> Enum.map(fn {_, phases} ->
            phases
            |> Map.to_list()
            |> Enum.map(fn {_, applications} -> applications end)
            |> Enum.concat()
          end)
          |> Enum.concat()
        end)
        |> Enum.concat()
      end)
      |> Enum.concat()
      |> Enum.map(fn application ->
        display_name =
          application
          |> Map.get("name")
          |> String.downcase()
          |> String.replace(~r/\s+/, "")
          |> String.replace(~r/[^\p{L}]/u, "")

        application
        |> Map.put_new("display_name", display_name)
      end)
      |> Enum.uniq_by(fn student ->
        Map.get(student, "civil_id") <> Map.get(student, "display_name")
      end)

    Students.create_students(students)

    IO.inspect("Storing #{length(students)} Students from seeds")
  end
end

Seeds.load_json_file_until_success(["./applications.json", "./priv/repo/seeds.json"])
