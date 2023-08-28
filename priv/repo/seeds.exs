alias FindYourFriendUniversity.Universities
alias FindYourFriendUniversity.Courses
alias FindYourFriendUniversity.Students
alias FindYourFriendUniversity.Applications
import FindYourFriendUniversity.Helpers

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

  defp load_json(json) do
    # =======================
    # Courses
    # =======================

    courses =
      json
      |> Enum.reduce([], fn uni, courses_list -> courses_list ++ uni["courses"] end)
      |> Enum.uniq_by(fn course -> course |> Map.get("id") end)
      |> Enum.map(&map_keys_to_atoms(&1))

    case Courses.create_multiple_courses(courses) do
      {:ok, {created_courses, _}, _} ->
        IO.puts("Stored #{created_courses}/#{length(courses)} Courses from seeds ond DB.")

      {:error, errors} ->
        IO.inspect(errors, label: "Courses inserting errors: ")
        raise "Courses inserting error. See errors below."
    end

    # =======================
    # Universities
    # =======================

    universities =
      json
      |> Enum.map(fn uni ->
        uni
        |> Map.put(
          "courses_ids",
          uni["courses"] |> Enum.map(fn course -> course |> Map.get("id") end)
        )
        |> map_keys_to_atoms()
      end)

    case Universities.create_multiple_universities(universities) do
      {:ok, {created_universities, _}, _} ->
        IO.puts(
          "Stored #{created_universities}/#{length(universities)} Universities from seeds ond DB."
        )

      {:error, errors} ->
        IO.inspect(errors, label: "Universities inserting errors: ")
        raise "Universities inserting error. See errors below."
    end

    # =======================
    # Students + Applications
    # =======================

    IO.puts("\nPreparing Students and Applications creation. Can take some time!")

    applications =
      json
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
                  |> normalize_string()

                civil_id =
                  application
                  |> Map.get("civil_id")
                  |> String.replace("(...)", "xxx")

                student_id = civil_id <> display_name

                application
                # Application parents info
                |> Map.put("university_id", uni["id"])
                |> Map.put("course_id", course["id"])
                |> Map.put("year", year)
                |> Map.put("phase", phase)
                # Application Grades
                |> Map.update!("candidature_grade", &parse_string_grades/1)
                |> Map.update!("exams_grades", &parse_string_grades/1)
                |> Map.update!("_12grade", &parse_string_grades/1)
                |> Map.update!("_11grade", &parse_string_grades/1)
                # Student Info
                |> Map.put_new("display_name", display_name)
                |> Map.update!("civil_id", fn _ -> civil_id end)
                |> Map.put_new("placed", false)
                |> Map.update!("student_option_number", &str_to_int/1)
                |> Map.update!("course_order_num", &str_to_int/1)
                |> Map.update!("phase", &str_to_int/1)
                |> Map.update!("year", &str_to_int/1)
                # To create student on DB
                |> Map.put_new("id", student_id)
                # To create application (association with student)
                |> Map.put_new("student_id", student_id)
                |> map_keys_to_atoms()
              end)
            end)
          end)
        end)
      end)
      |> List.flatten()

    # =======================
    # Students
    # =======================

    students =
      applications
      |> Enum.uniq_by(fn student -> student |> Map.get(:id) end)

    case Students.create_multiple_students(students) do
      {:ok, {created_students, _}} ->
        IO.puts("Stored #{created_students}/#{length(students)} Students from seeds ond DB.")

      {:error, errors} ->
        IO.inspect(errors, label: "Students inserting errors: ")
        raise "Students inserting error. See errors below."
    end

    # =======================
    # Applications
    # =======================

    case Applications.create_multiple_applications(applications) do
      {:ok, {created_applications, _}} ->
        IO.puts(
          "Stored #{created_applications}/#{length(applications)} Applications from seeds ond DB."
        )

      {:error, errors} ->
        IO.inspect(errors, label: "Applications inserting errors: ")
        raise "Applications inserting error. See errors below."
    end
  end

  defp parse_string_grades(grade) do
    {grade, _} =
      grade
      |> String.replace(",", ".")
      |> Float.parse()

    # all grades are stored at json as 123,4
    # all grades need be represented with 4 digits -> 13.56 <=> 1356
    (grade * 10)
    |> trunc()
  end
end

Seeds.load_json_file_until_success(["./applications.json", "./priv/repo/seeds.json"])
# Seeds.load_json_file_until_success(["./priv/repo/seeds.json"])
