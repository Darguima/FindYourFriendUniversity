defmodule FindYourFriendUniversity.Locations do
  @moduledoc """
  The Locations context.
  """

  import Ecto.Query, warn: false
  alias FindYourFriendUniversity.Repo

  import FindYourFriendUniversity.Helpers

  alias FindYourFriendUniversity.Locations.Location

  @doc """
  Returns the list of locations.

  ## Examples

      iex> list_locations()
      [%Location{}, ...]

  """
  def list_locations do
    Repo.all(Location)
  end

  @doc """
  Returns the list of possible locations of the student with preloaded parish, county, and district information.

  This function searches for locations based on the student's name and civil ID:
  - **Name**: Uses the first name and last name (if available) with fuzzy matching
  - **Civil ID**: Takes the last 2 characters and matches locations with civil IDs ending with those characters

  ## Parameters

  - `student` - A %Student{} struct containing:

  ## Examples

      iex> student = %Student{name: "João Silva Santos", civil_id: "12345678"}
      iex> Locations.search_by_student(student)
      [%Location{
        name: "João Santos",
        civil_id: "xxxxx78",
        year: "2023",
        parish: %Parish{name: "São João"},
        parish: %{county: %County{name: "Lisboa"}},
        parish: %{county: %{district: %District{name: "Lisboa"}}}
      }, ...]
  """
  def search_by_student(student) do
    normalized_name =
      student.name
      |> normalize_string([32])
      |> String.split()
      |> case do
        [first] -> first
        [first | rest] -> "#{first} #{List.last(rest)}"
        [] -> ""
      end
      |> String.replace(" ", "%")
      |> IO.inspect(label: "Normalized Name")

    normalized_civil_id =
      student.civil_id
      |> String.slice(-2, 2)
      |> normalize_string(48..57)
      |> String.replace("x", "_")
      |> IO.inspect(label: "Normalized Civil ID")

    query =
      from(location in Location,
        preload: [parish: [county: :district]],
        order_by: location.name,
        where:
          ilike(location.name, ^"#{normalized_name}") and
            ilike(location.civil_id, ^"%#{normalized_civil_id}")
      )

    Repo.all(query)
  end

  @doc """
  Gets a single location.

  Raises `Ecto.NoResultsError` if the Location does not exist.

  ## Examples

      iex> get_location!(123)
      %Location{}

      iex> get_location!(456)
      ** (Ecto.NoResultsError)

  """
  def get_location!(id), do: Repo.get!(Location, id)

  @doc """
  Creates a location.

  ## Examples

      iex> create_location(%{field: value})
      {:ok, %Location{}}

      iex> create_location(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_location(attrs \\ %{}) do
    %Location{}
    |> Location.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates multiple People Locations.

  If everything is ok, it returns a tuple containing the number of entries stored and any returned result as second element.

  If the changeset detect some errors at some of the locations it will return a list of locations and its respective errors.

  ## Examples

      iex> create_multiple_locations(
              [
                %{
                  name: "Person name",
                  civil_id: "xxxxx178",
                  parish_id: "123",
                },
                ...
              ]
            )
      {:ok, {locations_inserted_quantity, [...]}}

      iex> create_multiple_locations([%{field: value}, %{field: value}, ...])
      {:error, [ %{location: %Location{}, errors: [ %Ecto.Changeset{} ]} ]}
  """
  def create_multiple_locations(locations) do
    timestamp =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.truncate(:second)

    locations =
      locations
      |> Enum.map(fn location ->
        %{
          name: location.name,
          civil_id: location.civil_id,
          parish_id: location.parish_id,
          year: location.year,
          inserted_at: timestamp,
          updated_at: timestamp
        }
      end)

    errors =
      locations
      |> Enum.map(fn location ->
        errors =
          Location.changeset(%Location{}, location)
          |> Map.get(:errors)

        %{location: location, errors: errors}
      end)
      |> Enum.filter(fn location -> location.errors != [] end)

    if errors != [] do
      {:error, errors}
    else
      locations_inserted =
        locations
        # 65535 is the maximum of parameters per query; 6 the number of params per row
        |> Enum.chunk_every(trunc(65535 / 6))
        |> Enum.map(fn location -> Repo.insert_all(Location, location, on_conflict: :nothing) end)
        |> reduce_multiple_insert_all()

      {:ok, locations_inserted}
    end
  end

  @doc """
  Updates a location.

  ## Examples

      iex> update_location(location, %{field: new_value})
      {:ok, %Location{}}

      iex> update_location(location, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_location(%Location{} = location, attrs) do
    location
    |> Location.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a location.

  ## Examples

      iex> delete_location(location)
      {:ok, %Location{}}

      iex> delete_location(location)
      {:error, %Ecto.Changeset{}}

  """
  def delete_location(%Location{} = location) do
    Repo.delete(location)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking location changes.

  ## Examples

      iex> change_location(location)
      %Ecto.Changeset{data: %Location{}}

  """
  def change_location(%Location{} = location, attrs \\ %{}) do
    Location.changeset(location, attrs)
  end
end
