defmodule FindYourFriendUniversity.Applications do
  @moduledoc """
  The Applications context.
  """

  import Ecto.Query, warn: false
  alias FindYourFriendUniversity.Repo

  alias FindYourFriendUniversity.Applications.Application

  @doc """
  Returns the list of applications.

  ## Examples

      iex> list_applications()
      [%Application{}, ...]

  """
  def list_applications do
    Repo.all(Application)
  end

  @doc """
  Gets a single application.

  Raises `Ecto.NoResultsError` if the Application does not exist.

  ## Examples

      iex> get_application!(123)
      %Application{}

      iex> get_application!(456)
      ** (Ecto.NoResultsError)

  """
  def get_application!(id), do: Repo.get!(Application, id)

  @doc """
  Creates a application.

  ## Examples

      iex> create_application(%{field: value})
      {:ok, %Application{}}

      iex> create_application(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_application(attrs \\ %{}) do
    %Application{}
    |> Application.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates multiple applications.

  ## Examples

      iex> create_applications([%{field: value}, %{field: value}, ...])
      nil
  """
  def create_applications(applications \\ []) do
    timestamp =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.truncate(:second)

    applications
    |> Enum.map(fn application ->
      %{
        _11grade: application["_11grade"],
        _12grade: application["_12grade"],
        candidature_grade: application["candidature_grade"],
        exams_grades: application["exams_grades"],

        course_order_num: application["course_order_num"],
        student_option_number: application["student_option_number"],
        placed: application["placed"],

        year: application["year"],
        phase: application["phase"],

        university_id: application["university"],
        course_id: application["course"],
        student_id: application["student"],

        inserted_at: timestamp,
        updated_at: timestamp
      }
    end)
    # 65535 is the maximum of parameters per query; 14 the number of params per row
    |> Enum.chunk_every(trunc(65535 / 14))
    |> Enum.each(fn applications -> Repo.insert_all(Application, applications) end)
  end

  @doc """
  Updates a application.

  ## Examples

      iex> update_application(application, %{field: new_value})
      {:ok, %Application{}}

      iex> update_application(application, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_application(%Application{} = application, attrs) do
    application
    |> Application.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a application.

  ## Examples

      iex> delete_application(application)
      {:ok, %Application{}}

      iex> delete_application(application)
      {:error, %Ecto.Changeset{}}

  """
  def delete_application(%Application{} = application) do
    Repo.delete(application)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking application changes.

  ## Examples

      iex> change_application(application)
      %Ecto.Changeset{data: %Application{}}

  """
  def change_application(%Application{} = application, attrs \\ %{}) do
    Application.changeset(application, attrs)
  end
end
