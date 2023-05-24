defmodule FindYourFriendUniversity.Courses do
  @moduledoc """
  The Courses context.
  """

  import Ecto.Query, warn: false
  alias FindYourFriendUniversity.Universities
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
  Returns the list of courses from a given university.

  ## Examples

      iex> list_courses_from_university(3)
      [%Course{}, ...]

  """
  def list_courses_from_university(university_id) do
    university_courses_id =
      from(rel in "universities_courses",
        where: rel.university_id == ^university_id,
        select: rel.course_id
      )
      |> Repo.all()

    list_courses()
    |> Enum.filter(fn course -> course.id in university_courses_id end)
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
      from(rel in "universities_courses",
        where: rel.university_id == ^university_id,
        select: rel.course_id
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

  ## Examples

      iex> get_courses([1, 2])
      []

      iex> get_courses([3, 4])
      [%Course{}]

  """
  def get_courses(nil), do: []

  def get_courses(courses_ids), do: Repo.all(from(course in Course, where: course.id in ^courses_ids))

  defp put_assoc_universities(changeset, attrs) do
    universities = Universities.get_universities(attrs["universities_ids"])
    Ecto.Changeset.put_assoc(changeset, :universities, universities)
  end

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
    |> put_assoc_universities(attrs)
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
    |> put_assoc_universities(attrs)
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
