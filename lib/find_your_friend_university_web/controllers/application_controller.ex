defmodule FindYourFriendUniversityWeb.ApplicationController do
  use FindYourFriendUniversityWeb, :controller

  alias FindYourFriendUniversity.Universities
  alias FindYourFriendUniversity.Courses
  alias FindYourFriendUniversity.Students
  alias FindYourFriendUniversity.Repo

  alias FindYourFriendUniversity.Applications
  alias FindYourFriendUniversity.Applications.Application

  def index(conn, _params) do
    applications = Applications.list_applications()
    render(conn, :index, applications: applications)
  end

  def new(conn, _params) do
    changeset = Applications.change_application(%Application{})

    universities = Universities.list_universities()
    courses = Courses.list_courses()
    students = Students.list_students()

    render(conn, :new,
      changeset: changeset,
      universities: universities,
      courses: courses,
      students: students
    )
  end

  def create(conn, %{"application" => application_params}) do
    case Applications.create_application(application_params) do
      {:ok, application} ->
        conn
        |> put_flash(:info, "Application created successfully.")
        |> redirect(to: ~p"/applications/#{application}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    application =
      Applications.get_application!(id)
      |> Repo.preload(:university)
      |> Repo.preload(:course)
      |> Repo.preload(:student)

    render(conn, :show, application: application)
  end

  def edit(conn, %{"id" => id}) do
    application =
      Applications.get_application!(id)
      |> Repo.preload(:university)
      |> Repo.preload(:course)
      |> Repo.preload(:student)

    changeset = Applications.change_application(application)

    render(conn, :edit, application: application, changeset: changeset)
  end

  def update(conn, %{"id" => id, "application" => application_params}) do
    application =
      Applications.get_application!(id)
      |> Repo.preload(:university)
      |> Repo.preload(:course)
      |> Repo.preload(:student)

    case Applications.update_application(application, application_params) do
      {:ok, application} ->
        conn
        |> put_flash(:info, "Application updated successfully.")
        |> redirect(to: ~p"/applications/#{application}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, application: application, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    application = Applications.get_application!(id)
    {:ok, _application} = Applications.delete_application(application)

    conn
    |> put_flash(:info, "Application deleted successfully.")
    |> redirect(to: ~p"/applications")
  end
end
