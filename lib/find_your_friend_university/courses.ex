defmodule FindYourFriendUniversity.Courses do
  @moduledoc """
  The Courses context.
  """

  import Ecto.Query, warn: false
  alias FindYourFriendUniversity.Repo

  alias FindYourFriendUniversity.Courses.Course

  @doc """
  Returns the list of courses.

  ## Examples

      iex> list_courses()
      [%Course{}, ...]

  """
  def list_courses do
    Repo.all(Course)
  end

  @doc """
  Returns the list of courses, identifying the ones that the given university have.

  ## Examples

      iex> list_courses_and_existence_at_university(nil)
      [%{:not_exists, %Course{}}, ...]

      iex> list_courses_and_existence_at_university(3)
      [%{:exists, %Course{}}, ..., %{:not_exists, %Course{}}, ...]

  """
  def list_courses_and_existence_at_university(nil) do
    list_courses()
    |> Enum.map(fn course ->
      {:not_exists, course}
    end)
  end

  def list_courses_and_existence_at_university(university_id) do
    university_courses_id =
      from(uni in "university_courses",
        where: uni.university_id == ^university_id,
        select: uni.course_id
      )
      |> Repo.all()

    list_courses()
    |> Enum.map(fn course ->
      if course.id in university_courses_id do
        {:exists, course}
      else
        {:not_exists, course}
      end
    end)
  end

  @doc """
  Gets a single course.

  Raises `Ecto.NoResultsError` if the Course does not exist.

  ## Examples

      iex> get_course!(123)
      %Course{}

      iex> get_course!(456)
      ** (Ecto.NoResultsError)

  """
  def get_course!(id), do: Repo.get!(Course, id)

  @doc """
  Gets multiple courses.

  Raises o error if the Courses does not exist.

  ## Examples

      iex> get_courses([1, 2])
      [%Course{}]

  """
  def get_courses(nil), do: []

  def get_courses(ids), do: Repo.all(from(a in Course, where: a.id in ^ids))

  @doc """
  Creates a course.

  ## Examples

      iex> create_course(%{field: value})
      {:ok, %Course{}}

      iex> create_course(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_course(attrs \\ %{}) do
    %Course{}
    |> Course.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a course.

  ## Examples

      iex> update_course(course, %{field: new_value})
      {:ok, %Course{}}

      iex> update_course(course, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_course(%Course{} = course, attrs) do
    course
    |> Course.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a course.

  ## Examples

      iex> delete_course(course)
      {:ok, %Course{}}

      iex> delete_course(course)
      {:error, %Ecto.Changeset{}}

  """
  def delete_course(%Course{} = course) do
    Repo.delete(course)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking course changes.

  ## Examples

      iex> change_course(course)
      %Ecto.Changeset{data: %Course{}}

  """
  def change_course(%Course{} = course, attrs \\ %{}) do
    Course.changeset(course, attrs)
  end
end
