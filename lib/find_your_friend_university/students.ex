defmodule FindYourFriendUniversity.Students do
  @moduledoc """
  The Students context.
  """

  import Ecto.Query, warn: false
  import FindYourFriendUniversity.Helpers

  alias FindYourFriendUniversity.Repo

  alias FindYourFriendUniversity.Applications.Application
  alias FindYourFriendUniversity.Students.Student

  @doc """
  Returns the list of students.

  ## Examples

      iex> list_students()
      [%Student{}, ...]

  """
  def list_students do
    Repo.all(Student)
  end

  @doc """
  Returns the list of students that match the filters.

  ## Filters

  ```elixir
  students_filters = {
    :name, # The name to search. It need be in the correct order
    :civil_id, # The civil id to search. Can be used 'x' to match any number

    :universities_applications, # An array with universities ids. The returned students will have applications to this university
    :courses_applications, # An array with courses ids. The returned students will have applications to this course

    :years_applications, # An array with years. The returned students will have applications during on this year
    :phases_applications, # An array with phases. The returned students will have applications on this phase

    :page_size, # How much students are presented inside a page
    :page_number # The page number,
  }
  ```

  ## Examples

      iex> Students.search_students(%{
        name: "Some name to search",

        universities_applications: ["1234", "5678"],

        page_number: 4,
        page_size: 50
      })
      [%Student{}, ...]
  """
  def search_students(filters) do
    filters =
      filters
      |> Map.update!(:name, fn name ->
        name
        |> normalize_string([32])
        |> String.replace(" ", "%")
      end)
      |> Map.update!(:civil_id, fn civil_id ->
        civil_id
        |> normalize_string(48..57)
        |> String.replace("x", "%")
      end)

    query =
      from(student in Student,
        order_by: student.name,
        join: application in Application,
        on: application.student_id == student.id,
        where:
          ilike(student.display_name, ^"%#{filters.name}%") and
            ilike(student.civil_id, ^"%#{filters.civil_id}%") and
            application.university_id in ^filters.universities_applications and
            application.course_id in ^filters.courses_applications and
            application.year in ^filters.years_applications and
            application.phase in ^filters.phases_applications,
        limit: ^filters.page_size,
        offset: (^filters.page_number - 1) * ^filters.page_size,
        select: student,
        distinct: student
      )

    Repo.all(query)
  end

  @doc """
  Gets a single student.

  Raises `Ecto.NoResultsError` if the Student does not exist.

  ## Examples

      iex> get_student!(123)
      %Student{}

      iex> get_student!(456)
      ** (Ecto.NoResultsError)

  """
  def get_student!(id), do: Repo.get!(Student, id)

  @doc """
  Creates a student.

  ## Examples

      iex> create_student(%{field: value})
      {:ok, %Student{}}

      iex> create_student(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_student(attrs \\ %{}) do
    %Student{}
    |> Student.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates multiple students.

  If everything is ok, it returns a tuple containing the number of entries stored and any returned result as second element.

  If the changeset detect some errors at some of the students it will return a list of students and its respective errors.

  ## Examples

      iex> create_multiple_students(
              [
                %{
                  id: "123xxx78studentname",
                  name: "Student name",
                  display_name: "studentname",
                  civil_id: "123xxx78",
                },
                ...
              ]
            )
      {:ok, {students_inserted_quantity, [...]}}

      iex> create_multiple_students([%{field: value}, %{field: value}, ...])
      {:error, [ %{student: %Student{}, errors: [ %Ecto.Changeset{} ]} ]}
  """
  def create_multiple_students(students) do
    timestamp =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.truncate(:second)

    students =
      students
      |> Enum.map(fn student ->
        %{
          id: student |> Map.get(:id),
          name: student |> Map.get(:name),
          display_name: student |> Map.get(:display_name),
          civil_id: student |> Map.get(:civil_id),
          inserted_at: timestamp,
          updated_at: timestamp
        }
      end)

    errors =
      students
      |> Enum.map(fn student ->
        errors =
          Student.changeset(%Student{}, student)
          |> Map.get(:errors)

        %{student: student, errors: errors}
      end)
      |> Enum.filter(fn student -> student.errors != [] end)

    if errors != [] do
      {:error, errors}
    else
      students_inserted =
        students
        # 65535 is the maximum of parameters per query; 6 the number of params per row
        |> Enum.chunk_every(trunc(65535 / 6))
        |> Enum.map(fn student -> Repo.insert_all(Student, student, conflict_target: :id, on_conflict: {:replace_all_except, [:id, :inserted_at]}) end)
        |> reduce_multiple_insert_all()

      {:ok, students_inserted}
    end
  end

  @doc """
  Updates a student.

  ## Examples

      iex> update_student(student, %{field: new_value})
      {:ok, %Student{}}

      iex> update_student(student, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_student(%Student{} = student, attrs) do
    student
    |> Student.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a student.

  ## Examples

      iex> delete_student(student)
      {:ok, %Student{}}

      iex> delete_student(student)
      {:error, %Ecto.Changeset{}}

  """
  def delete_student(%Student{} = student) do
    Repo.delete(student)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking student changes.

  ## Examples

      iex> change_student(student)
      %Ecto.Changeset{data: %Student{}}

  """
  def change_student(%Student{} = student, attrs \\ %{}) do
    Student.changeset(student, attrs)
  end
end
