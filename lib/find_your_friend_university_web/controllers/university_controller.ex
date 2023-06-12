defmodule FindYourFriendUniversityWeb.UniversityController do
  use FindYourFriendUniversityWeb, :controller

  alias FindYourFriendUniversity.Repo
  alias FindYourFriendUniversity.Universities
  alias FindYourFriendUniversity.Universities.University

  def index(conn, _params) do
    universities = Universities.list_universities()
    render(conn, :index, universities: universities)
  end

  def new(conn, _params) do
    changeset = Universities.change_university(%University{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"university" => university_params}) do
    case Universities.create_university(university_params) do
      {:ok, university} ->
        conn
        |> put_flash(:info, "University created successfully.")
        |> redirect(to: ~p"/universities/#{university}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    university = Universities.get_university!(id)
    render(conn, :show, university: university)
  end

  def edit(conn, %{"id" => id}) do
    university = Universities.get_university!(id)
    |> Repo.preload(:courses)
    changeset = Universities.change_university(university)
    render(conn, :edit, university: university, changeset: changeset)
  end

  def update(conn, %{"id" => id, "university" => university_params}) do
    university = Universities.get_university!(id)

    case Universities.update_university(university, university_params) do
      {:ok, university} ->
        conn
        |> put_flash(:info, "University updated successfully.")
        |> redirect(to: ~p"/universities/#{university}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, university: university, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    university = Universities.get_university!(id)
    {:ok, _university} = Universities.delete_university(university)

    conn
    |> put_flash(:info, "University deleted successfully.")
    |> redirect(to: ~p"/universities")
  end
end
