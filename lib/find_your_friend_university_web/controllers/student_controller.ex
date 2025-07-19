defmodule FindYourFriendUniversityWeb.StudentController do
  use FindYourFriendUniversityWeb, :controller

  import Ecto.Query
  alias FindYourFriendUniversity.Universities
  alias FindYourFriendUniversity.Courses
  alias FindYourFriendUniversity.Repo
  alias FindYourFriendUniversity.Students
  alias FindYourFriendUniversity.Locations
  alias FindYourFriendUniversity.Applications.Application
  import FindYourFriendUniversity.Helpers
  alias FindYourFriendUniversity.SearchHistory

  def index(conn, params) do
    universities_available = Universities.list_universities()
    courses_available = Courses.list_courses()

    filters =
      params
      |> Map.put_new("name", "")
      |> Map.put_new("civil_id", "")
      |> Map.update(
        "universities_applications",
        universities_available |> Enum.map(fn uni -> uni.id end),
        fn array -> Enum.filter(array, fn elem -> elem != "" end) end
      )

      |> Map.update(
        "courses_applications",
        courses_available |> Enum.map(fn course -> course.id end),
        fn array -> Enum.filter(array, fn elem -> elem != "" end) end
      )
      |> Map.update(
        "years_applications",
        2018..2024 |> Enum.map(&Integer.to_string(&1)),
        fn array -> Enum.filter(array, fn elem -> elem != "" end) end

      )
      |> Map.update(
        "phases_applications",
        1..3 |> Enum.map(&Integer.to_string(&1)),
        fn array -> Enum.filter(array, fn elem -> elem != "" end) end
      )
      |> Map.update("page_number", 1, fn string ->
        string
        |> Integer.parse()
        |> elem(0)
      end)
      |> Map.update("page_size", 100, fn string ->
        string
        |> Integer.parse()
        |> elem(0)
      end)
      |> Map.take([
        "name",
        "civil_id",
        "universities_applications",
        "courses_applications",
        "years_applications",
        "phases_applications",
        "page_number",
        "page_size"
      ])
      |> map_keys_to_atoms()

    students = if params == %{}, do: [], else: Students.search_students(filters)

    if params != %{} do
      SearchHistory.create_search_history(filters)
    end

    render(conn, :index,
      students: students,
      filters: filters,
      universities: universities_available,
      courses: courses_available
    )
  end

  def show(conn, %{"id" => id}) do
    student = Students.get_student!(id)

    applications =
      student
      |> Repo.preload(
        applications:
          from(a in Application,
            order_by: [desc: a.year, asc: a.phase, asc: a.student_option_number]
          )
      )
      |> Map.get(:applications)
      |> Enum.map(fn application ->
        application
        |> Repo.preload([:course, :university])
        |> Map.update!(:_11grade, fn grade -> grade / 100 end)
        |> Map.update!(:_12grade, fn grade -> grade / 100 end)
        |> Map.update!(:exams_grades, fn grade -> grade / 100 end)
        |> Map.update!(:candidature_grade, fn grade -> grade / 100 end)
      end)

    locations = Locations.search_by_student(student)

    render(conn, :show, student: student, applications: applications, locations: locations)
  end
end
