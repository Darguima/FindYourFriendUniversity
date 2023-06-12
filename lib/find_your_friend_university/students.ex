defmodule FindYourFriendUniversity.Students do
  @moduledoc """
  The Students context.
  """

  import Ecto.Query, warn: false
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
  Don't have yet a good doc. I need write it.
  """
  def search_students(filters) do
    ilike_query =
      filters
      |> Map.get(:name, "")
      |> String.downcase()
      |> String.normalize(:nfd)
      |> String.to_charlist()
      |> Enum.filter(fn char -> (97 <= char && char <= 122) || char == 32 end)
      |> List.to_string()
      |> String.replace(" ", "%")

    page_size =
      filters
      |> Map.get(:page_size, 100)

    page_number =
      filters
      |> Map.get(:page_number, 1)

    query =
      from(s in Student,
        where: ilike(s.display_name, ^"%#{ilike_query}%"),
        select: s,
        order_by: s.name,
        limit: ^page_size,
        offset: (^page_number - 1) * ^page_size
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
  Gets a single student name.

  Raises `Ecto.NoResultsError` if the Student does not exist.

  ## Examples

      iex> get_student_name!(123)
      "Mike Obama"

      iex> get_student_name!(456)
      ** (Ecto.NoResultsError)

  """
  def get_student_name!(id),
    do: Repo.one!(from(student in Student, where: student.id == ^id, select: student.name))

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

  ## Examples

      iex> create_students([%{field: value}, %{field: value}, ...])
      nil
  """
  def create_students(students \\ []) do
    timestamp =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.truncate(:second)

    students
    |> Enum.map(fn student ->
      %{
        id: student["id"],
        name: student["name"],
        display_name: student["display_name"],
        civil_id: student["civil_id"],
        inserted_at: timestamp,
        updated_at: timestamp
      }
    end)
    # 65535 is the maximum of parameters per query; 6 the number of params per row
    |> Enum.chunk_every(trunc(65535 / 6))
    |> Enum.each(fn students -> Repo.insert_all(Student, students) end)
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
