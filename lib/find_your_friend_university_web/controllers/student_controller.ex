defmodule FindYourFriendUniversityWeb.StudentController do
  use FindYourFriendUniversityWeb, :controller

  import Ecto.Query
  alias FindYourFriendUniversity.Repo
  alias FindYourFriendUniversity.Students
  alias FindYourFriendUniversity.Students.Student
  alias FindYourFriendUniversity.Applications.Application

  def index(conn, _params) do
    students = Students.list_students()
    render(conn, :index, students: students)
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
