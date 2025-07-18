defmodule FindYourFriendUniversity.Courses do
  @moduledoc """
  The Courses context.
  """

  import Ecto.Query, warn: false
  import FindYourFriendUniversity.Helpers

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
  Creates multiple courses.

  If everything is ok, it returns two tuples, both containing the number of entries stored and any returned result as second element, from the courses and all associations inserted, respectively.

  If the changeset detect some errors at some of the courses it will return a list of courses and its respective errors.

  NOTE: changeset will not detect errors at associations.

  In some cases, like if one of the given university id don't exists it will raise an Postgres error

  ## Examples

      iex> create_multiple_courses(
              [
                %{
                  id: "1234",
                  name: "Course Name",
                  universities_ids: ["1234", "1111"], # Optional
                },
                ...
              ]
            )
      {:ok, {courses_inserted_quantity, [...]}, {associations_inserted_quantity, [...]}}

      iex> create_multiple_courses([%{field: value}, %{field: value}, ...])
      {:error, [ %{course: %Course{}, errors: [ %Ecto.Changeset{} ]} ]}

      # If, for example, one university id doesn't exists:
      iex> create_multiple_courses([%{field: value}, %{field: value}, ...])
      ** (Postgrex.Error) ERROR 23503 (foreign_key_violation)
  """
  def create_multiple_courses(courses) do
    timestamp =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.truncate(:second)

    courses =
      courses
      |> Enum.map(fn course ->
        %{
          id: course |> Map.get(:id),
          name: course |> Map.get(:name),
          universities_ids: course |> Map.get(:universities_ids, []),
          inserted_at: timestamp,
          updated_at: timestamp
        }
      end)

    errors =
      courses
      |> Enum.map(fn course ->
        errors =
          Course.changeset(%Course{}, course)
          |> Map.get(:errors)

        %{course: course, errors: errors}
      end)
      |> Enum.filter(fn course -> course.errors != [] end)

    if errors != [] do
      {:error, errors}
    else
      courses_inserted =
        courses
        |> Enum.map(fn course ->
          course
          |> Map.delete(:universities_ids)
        end)
        # 65535 is the maximum of parameters per query; 4 the number of params per row
        |> Enum.chunk_every(trunc(65535 / 4))
        |> Enum.map(fn course -> Repo.insert_all(Course, course, conflict_target: :id, on_conflict: {:replace_all_except, [:id, :inserted_at]}) end)
        |> reduce_multiple_insert_all()

      # Many to many association with universities:
      associations_inserted =
        courses
        |> Enum.map(fn course ->
          course
          |> Map.get(:universities_ids)
          |> Enum.map(fn uni_id -> %{university_id: uni_id, course_id: course.id} end)
        end)
        |> Enum.concat()
        # 65535 is the maximum of parameters per query; 2 the number of params per row
        |> Enum.chunk_every(trunc(65535 / 2))
        |> Enum.map(fn assoc -> Repo.insert_all("universities_courses", assoc, on_conflict: :nothing) end)
        |> reduce_multiple_insert_all()

      {:ok, courses_inserted, associations_inserted}
    end
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
