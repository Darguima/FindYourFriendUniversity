defmodule FindYourFriendUniversity.Universities do
  @moduledoc """
  The Universities context.
  """

  import Ecto.Query, warn: false
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
  Returns the list of universities that have the given course.

  ## Examples

      iex> list_universities_from_course(3)
      [%University{}, ...]

  """
  def list_universities_from_course(course_id) do
    course_universities_ids =
      from(rel in "universities_courses",
        where: rel.course_id == ^course_id,
        select: rel.university_id
      )
      |> Repo.all()

    list_universities()
    |> Enum.filter(fn university -> university.id in course_universities_ids end)
  end

  @doc """
  Returns the list of universities, identifying the ones that the have the given course.

  ## Examples

      iex> list_universities_and_existence_of_course(nil)
      [%{:not_exists, %University{}}, ...]

      iex> list_universities_and_existence_of_course(3)
      [%{:exists, %University{}}, ..., %{:not_exists, %University{}}, ...]

  """
  def list_universities_and_existence_of_course(nil) do
    list_universities()
    |> Enum.map(fn uni -> {:not_exists, uni} end)
  end

  def list_universities_and_existence_of_course(course_id) do
    course_universities_ids =
      from(rel in "universities_courses",
        where: rel.course_id == ^course_id,
        select: rel.university_id
      )
      |> Repo.all()

    list_universities()
    |> Enum.map(fn uni ->
      if uni.id in course_universities_ids do
        {:exists, uni}
      else
        {:not_exists, uni}
      end
    end)
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

  @doc """
  Gets a single university name.

  Raises `Ecto.NoResultsError` if the University does not exist.

  ## Examples

      iex> get_university_name!(123)
      "Universidade do Minho"

      iex> get_university_name!(456)
      ** (Ecto.NoResultsError)

  """
  def get_university_name!(id),
    do: Repo.one!(from(uni in University, where: uni.id == ^id, select: uni.name))

  @doc """
  Gets multiple universities.

  ## Examples

      iex> get_universities([1, 2])
      []

      iex> get_universities([3, 4])
      [%University{}]

  """
  def get_universities(nil), do: []

  def get_universities(uni_ids), do: Repo.all(from(uni in University, where: uni.id in ^uni_ids))

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
    |> Repo.insert()
  end

  @doc """
  Creates multiple universities.

  ## Examples

      iex> create_universities([%{field: value}, %{field: value}, ...])
      nil
  """
  def create_universities(universities \\ []) do
    universities
    |> Enum.each(&create_university(&1))
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
    |> Repo.preload(:courses)
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
