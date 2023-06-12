defmodule FindYourFriendUniversityWeb.StudentController do
  use FindYourFriendUniversityWeb, :controller

  import Ecto.Query
  alias FindYourFriendUniversity.Repo
  alias FindYourFriendUniversity.Students
  alias FindYourFriendUniversity.Students.Student
  alias FindYourFriendUniversity.Applications.Application

  def index(conn, params) do
    # https://stackoverflow.com/questions/52460139/how-do-you-do-search-sorting-pagination-in-phoenix-framework
    # https://github.blog/2015-11-03-like-injection/
    # https://medium.com/@aditya7iyengar/searching-sorting-and-pagination-in-elixir-phoenix-with-rummage-part-3-7cf5023bc226
    # students = Students.list_students()

    search_name =
      params
      |> Map.get("search_name", "")

    page_number =
      params
      |> Map.get("page_number", "1")
      |> Integer.parse()
      |> elem(0)
      |> (fn pn -> if pn <= 1, do: 1, else: pn end).()

    page_size =
      params
      |> Map.get("page_size", "100")
      |> Integer.parse()
      |> elem(0)
      |> (fn ps -> if ps <= 1, do: 1, else: ps end).()

    filters = %{
      name: search_name,
      page_number: page_number,
      page_size: page_size
    }

    students = Students.search_students(filters)

    render(conn, :index, students: students, filters: filters)
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
    student =
      Students.get_student!(id)
      |> Repo.preload(
        applications:
          from(a in Application,
            order_by: [desc: a.year, asc: a.phase, asc: a.student_option_number]
          )
      )
      |> Map.update!(:applications, fn applications ->
        applications
        |> Repo.preload([:course, :university])
        |> Enum.map(fn application ->
          application
          |> Map.update!(:_11grade, fn grade -> grade / 100 end)
          |> Map.update!(:_12grade, fn grade -> grade / 100 end)
          |> Map.update!(:exams_grades, fn grade -> grade / 100 end)
          |> Map.update!(:candidature_grade, fn grade -> grade / 100 end)
        end)
      end)

    render(conn, :show, student: student)
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
