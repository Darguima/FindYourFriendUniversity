defmodule FindYourFriendUniversityWeb.CourseController do
  use FindYourFriendUniversityWeb, :controller

  alias FindYourFriendUniversity.Repo
  alias FindYourFriendUniversity.Courses
  alias FindYourFriendUniversity.Courses.Course

  def index(conn, _params) do
    courses = Courses.list_courses()
    render(conn, :index, courses: courses)
  end

  def new(conn, _params) do
    changeset = Courses.change_course(%Course{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"course" => course_params}) do
    case Courses.create_course(course_params) do
      {:ok, course} ->
        conn
        |> put_flash(:info, "Course created successfully.")
        |> redirect(to: ~p"/courses/#{course}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    course = Courses.get_course!(id)
    render(conn, :show, course: course)
  end

  def edit(conn, %{"id" => id}) do
    course = Courses.get_course!(id)
    |> Repo.preload(:universities)
    changeset = Courses.change_course(course)
    render(conn, :edit, course: course, changeset: changeset)
  end

  def update(conn, %{"id" => id, "course" => course_params}) do
    course = Courses.get_course!(id)

    case Courses.update_course(course, course_params) do
      {:ok, course} ->
        conn
        |> put_flash(:info, "Course updated successfully.")
        |> redirect(to: ~p"/courses/#{course}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, course: course, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    course = Courses.get_course!(id)
    {:ok, _course} = Courses.delete_course(course)

    conn
    |> put_flash(:info, "Course deleted successfully.")
    |> redirect(to: ~p"/courses")
  end
end
