defmodule FindYourFriendUniversity.Applications do
  @moduledoc """
  The Applications context.
  """

  import Ecto.Query, warn: false
  import FindYourFriendUniversity.Helpers

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

  If everything is ok, it returns a tuple containing the number of entries stored and any returned result as second element.

  If the changeset detect some errors at some of the applications it will return a list of applications and its respective errors.

  NOTE: changeset will not detect errors at associations.

  In some cases, like if one of the given university/course/student ids don't exists it will raise an Postgres error

  ## Examples

      iex> create_multiple_applications(
              [
                %{
                  _11grade: 18,
                  _12grade: 13,
                  candidature_grade: 16,
                  exams_grades: 15,

                  student_option_number: 2,
                  placed: true,

                  year: 2019
                  phase: 2,

                  course_order_num: 98,

                  university_id: "1234",
                  course_id: "1234",
                  student_id: "1234",
                },
                ...
              ]
            )
      {:ok, {applications_inserted_quantity, [...]}}

      iex> create_multiple_applications([%{field: value}, %{field: value}, ...])
      {:error, [ %{application: %Application{}, errors: [ %Ecto.Changeset{} ]} ]}

      # If, for example, one university/course/student id doesn't exists:
      iex> create_multiple_applications([%{field: value}, %{field: value}, ...])
      ** (Postgrex.Error) ERROR 23503 (foreign_key_violation)
  """

  def create_multiple_applications(applications) do
    timestamp =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.truncate(:second)

    applications =
      applications
      |> Enum.map(fn application ->
        %{
          _11grade: application |> Map.get(:_11grade),
          _12grade: application |> Map.get(:_12grade),
          candidature_grade: application |> Map.get(:candidature_grade),
          exams_grades: application |> Map.get(:exams_grades),
          student_option_number: application |> Map.get(:student_option_number),
          placed: application |> Map.get(:placed),
          course_order_num: application |> Map.get(:course_order_num),
          year: application |> Map.get(:year),
          phase: application |> Map.get(:phase),
          university_id: application |> Map.get(:university_id),
          course_id: application |> Map.get(:course_id),
          student_id: application |> Map.get(:student_id),
          inserted_at: timestamp,
          updated_at: timestamp
        }
      end)

    errors =
      applications
      |> Enum.map(fn application ->
        errors =
          Application.changeset(%Application{}, application)
          |> Map.get(:errors)

        %{application: application, errors: errors}
      end)
      |> Enum.filter(fn application -> application.errors != [] end)

    if errors != [] do
      {:error, errors}
    else
      applications_inserted =
        applications
        # 65535 is the maximum of parameters per query; 4 the number of params per row
        |> Enum.chunk_every(trunc(65535 / 14))
        |> Enum.map(fn application -> Repo.insert_all(Application, application) end)
        |> reduce_multiple_insert_all()

      {:ok, applications_inserted}
    end
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
