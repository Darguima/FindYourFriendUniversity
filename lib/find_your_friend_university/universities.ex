defmodule FindYourFriendUniversity.Universities do
  @moduledoc """
  The Universities context.
  """

  import Ecto.Query, warn: false
  import FindYourFriendUniversity.Helpers

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

  If everything is ok, it returns two tuples, both containing the number of entries stored and any returned result as second element, from the universities and all associations inserted, respectively.

  If the changeset detect some errors at some of the universities it will return a list of universities and its respective errors.

  NOTE: changeset will not detect errors at associations.

  In some cases, like if one of the given course ids don't exists it will raise an Postgres error


  ## Examples

      iex> create_multiple_universities(
              [
                %{
                  id: "1234",
                  name: "University Name",
                  is_polytechnic: false
                  courses_ids: ["1234", "1111"], # Optional
                },
                ...
              ]
            )
      {:ok, {universities_inserted_quantity, [...]}, {associations_inserted_quantity, [...]}}

      iex> create_multiple_universities([%{field: value}, %{field: value}, ...])
      {:error, [ %{university: %University{}, errors: [ %Ecto.Changeset{} ]} ]}

      # If, for example, one course id doesn't exists:
      iex> create_multiple_universities([%{field: value}, %{field: value}, ...])
      ** (Postgrex.Error) ERROR 23503 (foreign_key_violation)
  """
  def create_multiple_universities(universities) do
    timestamp =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.truncate(:second)

    universities =
      universities
      |> Enum.map(fn university ->
        %{
          id: university |> Map.get(:id),
          name: university |> Map.get(:name),
          is_polytechnic: university |> Map.get(:is_polytechnic),
          courses_ids: university |> Map.get(:courses_ids, []),
          inserted_at: timestamp,
          updated_at: timestamp
        }
      end)

    errors =
      universities
      |> Enum.map(fn uni ->
        errors =
          University.changeset(%University{}, uni)
          |> Map.get(:errors)

        %{university: uni, errors: errors}
      end)
      |> Enum.filter(fn uni -> uni.errors != [] end)

    if errors != [] do
      {:error, errors}
    else
      universities_inserted =
        universities
        |> Enum.map(fn uni ->
          uni
          |> Map.delete(:courses_ids)
        end)
        # 65535 is the maximum of parameters per query; 4 the number of params per row
        |> Enum.chunk_every(trunc(65535 / 5))
        |> Enum.map(fn uni -> Repo.insert_all(University, uni, on_conflict: :nothing) end)
        |> reduce_multiple_insert_all()

      # Many to many association with universities:
      associations_inserted =
        universities
        |> Enum.map(fn university ->
          university
          |> Map.get(:courses_ids)
          |> Enum.map(fn course_id -> %{university_id: university.id, course_id: course_id} end)
        end)
        |> Enum.concat()
        # 65535 is the maximum of parameters per query; 2 the number of params per row
        |> Enum.chunk_every(trunc(65535 / 2))
        |> Enum.map(fn assoc -> Repo.insert_all("universities_courses", assoc, on_conflict: :nothing) end)
        |> reduce_multiple_insert_all()

      {:ok, universities_inserted, associations_inserted}
    end
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
