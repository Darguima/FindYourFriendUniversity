defmodule FindYourFriendUniversityWeb.StudentController do
  use FindYourFriendUniversityWeb, :controller

  import Ecto.Query
  alias FindYourFriendUniversity.Universities
  alias FindYourFriendUniversity.Courses
  alias FindYourFriendUniversity.Repo
  alias FindYourFriendUniversity.Students
  alias FindYourFriendUniversity.Students.Student
  alias FindYourFriendUniversity.Applications.Application
  import FindYourFriendUniversity.Helpers

  def index(conn, params) do
    universities_available = Universities.list_universities()
    courses_available = Courses.list_courses()

    filters =
      params
      |> Map.put_new("name", "")
      |> Map.put_new("civil_id", "")
      |> Map.put_new(
        "universities_applications",
        universities_available |> Enum.map(fn uni -> uni.id end)
      )
      |> Map.put_new(
        "courses_applications",
        courses_available |> Enum.map(fn course -> course.id end)
      )
      |> Map.put_new(
        "years_applications",
        2018..2023 |> Enum.map(&Integer.to_string(&1))
      )
      |> Map.put_new(
        "phases_applications",
        1..3 |> Enum.map(&Integer.to_string(&1))
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

    students = Students.search_students(filters)

    render(conn, :index,
      students: students,
      filters: filters,
      universities: universities_available,
      courses: courses_available
    )
  end

  def new(conn, _params) do
    changeset = Students.change_student(%Student{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"student" => student_params}) do
    case Students.create_student(student_params) do
      {:ok, student} ->
        conn
        |> put_flash(:info, "Student created successfully.")
        |> redirect(to: ~p"/students/#{student}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
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

    render(conn, :show, student: student, applications: applications)
  end

  def edit(conn, %{"id" => id}) do
    student = Students.get_student!(id)
    changeset = Students.change_student(student)
    render(conn, :edit, student: student, changeset: changeset)
  end

  def update(conn, %{"id" => id, "student" => student_params}) do
    student = Students.get_student!(id)

    case Students.update_student(student, student_params) do
      {:ok, student} ->
        conn
        |> put_flash(:info, "Student updated successfully.")
        |> redirect(to: ~p"/students/#{student}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, student: student, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    student = Students.get_student!(id)
    {:ok, _student} = Students.delete_student(student)

    conn
    |> put_flash(:info, "Student deleted successfully.")
    |> redirect(to: ~p"/students")
  end
end
