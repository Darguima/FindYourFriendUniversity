defmodule FindYourFriendUniversity.Universities do
  @moduledoc """
  The Universities context.
  """

  import Ecto.Query, warn: false
  alias FindYourFriendUniversity.Courses
  alias FindYourFriendUniversity.Repo

  alias FindYourFriendUniversity.Universities.University

  @doc """
  Returns the list of universities.

  ## Examples

      iex> list_universities()
      [%University{}, ...]

  """
  def list_universities do
    Repo.all(University)
  end

  @doc """
  Gets a single university.

  Raises `Ecto.NoResultsError` if the University does not exist.

  ## Examples

      iex> get_university!(123)
      %University{}

      iex> get_university!(456)
      ** (Ecto.NoResultsError)

  """
  def get_university!(id), do: Repo.get!(University, id)

  defp maybe_put_courses(changeset, attrs) do
    courses = Courses.get_courses(attrs["courses_ids"])
    Ecto.Changeset.put_assoc(changeset, :courses, courses)
  end

  @doc """
  Creates a university.

  ## Examples

      iex> create_university(%{field: value})
      {:ok, %University{}}

      iex> create_university(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_university(attrs \\ %{}) do
    %University{}
    |> University.changeset(attrs)
    |> maybe_put_courses(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a university.

  ## Examples

      iex> update_university(university, %{field: new_value})
      {:ok, %University{}}

      iex> update_university(university, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_university(%University{} = university, attrs) do
    university
    |> University.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a university.

  ## Examples

      iex> delete_university(university)
      {:ok, %University{}}

      iex> delete_university(university)
      {:error, %Ecto.Changeset{}}

  """
  def delete_university(%University{} = university) do
    Repo.delete(university)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking university changes.

  ## Examples

      iex> change_university(university)
      %Ecto.Changeset{data: %University{}}

  """
  def change_university(%University{} = university, attrs \\ %{}) do
    University.changeset(university, attrs)
  end
end
