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

    IO.puts("Storing #{length(courses)} Courses from seeds ond DB.")

    universities =
      seeds
      |> Enum.map(fn uni ->
        uni
        |> Map.put(
          "courses_ids",
          uni["courses"] |> Enum.map(fn course -> course |> Map.get("id") end)
        )
      end)

    Universities.create_universities(universities)

    IO.puts("Storing #{length(universities)} Universities from seeds ond DB.")

    IO.puts("\nPreparing Students and Applications creation. Can take some time!")

    applications =
      seeds
      |> Enum.map(fn uni ->
        uni["courses"]
        |> Enum.map(fn course ->
          course["applications"]
          |> Enum.map(fn {year, phases} ->
            phases
            |> Enum.map(fn {phase, applications} ->
              applications
              |> Enum.map(fn application ->
                display_name =
                  application
                  |> Map.get("name")
                  |> String.downcase()
                  |> String.normalize(:nfd)
                  |> String.to_charlist()
                  |> Enum.filter(fn char -> 97 <= char && char <= 122 end)
                  |> List.to_string()

                civil_id =
                  application
                  |> Map.get("civil_id")
                  |> String.replace("(...)", "xxx")

                student_id = civil_id <> display_name

                application
                # Application parents info
                |> Map.put("university", uni["id"])
                |> Map.put("course", course["id"])
                |> Map.put("year", year)
                |> Map.put("phase", phase)
                # Application Grades
                |> Map.update!("candidature_grade", &parse_grades/1)
                |> Map.update!("exams_grades", &parse_grades/1)
                |> Map.update!("_12grade", &parse_grades/1)
                |> Map.update!("_11grade", &parse_grades/1)
                # Student Info
                |> Map.put_new("display_name", display_name)
                |> Map.update!("civil_id", fn _ -> civil_id end)
                |> Map.put("placed", false)
                |> Map.update!("student_option_number", &parse_integer/1)
                |> Map.update!("course_order_num", &parse_integer/1)
                |> Map.update!("phase", &parse_integer/1)
                |> Map.update!("year", &parse_integer/1)
                # To create student on DB
                |> Map.put_new("id", student_id)
                # To create application (association with student)
                |> Map.put_new("student", student_id)
              end)
            end)
          end)
        end)
      end)
      |> List.flatten()

    students =
      applications
      |> Enum.uniq_by(fn student -> student |> Map.get("id") end)

    Students.create_students(students)

    IO.puts("Storing #{length(students)} Students from seeds ond DB.")

    Applications.create_applications(applications)

    IO.puts("Storing #{length(applications)} Applications from seeds ond DB.")
  end

  defp parse_grades(grade) do
    {grade, _} =
      grade
      |> String.replace(",", ".")
      |> Float.parse()

    # all grades are represented with 4 digits -> 13.56 <=> 1356
    if(grade < 1000, do: grade * 10, else: grade)
    |> trunc()
  end

  defp parse_integer(string) do
    string
    |> Integer.parse()
    |> elem(0)
  end
end

Seeds.load_json_file_until_success(["./applications.json", "./priv/repo/seeds.json"])
# Seeds.load_json_file_until_success(["./priv/repo/seeds.json"])
