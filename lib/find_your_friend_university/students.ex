defmodule FindYourFriendUniversity.Students do
  @moduledoc """
  The Students context.
  """

  import Ecto.Query, warn: false
  import FindYourFriendUniversity.Helpers

  alias FindYourFriendUniversity.Repo

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
        # 65535 is the maximum of parameters per query; 4 the number of params per row
        |> Enum.chunk_every(trunc(65535 / 6))
        |> Enum.map(fn student -> Repo.insert_all(Student, student) end)
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
