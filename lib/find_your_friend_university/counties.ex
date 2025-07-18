defmodule FindYourFriendUniversity.Counties do
  @moduledoc """
  The Counties context.
  """

  import Ecto.Query, warn: false
  alias FindYourFriendUniversity.Repo
  import FindYourFriendUniversity.Helpers

  alias FindYourFriendUniversity.Counties.County

  @doc """
  Returns the list of counties.

  ## Examples

      iex> list_counties()
      [%County{}, ...]

  """
  def list_counties do
    Repo.all(County)
  end

  @doc """
  Gets a single county.

  Raises `Ecto.NoResultsError` if the County does not exist.

  ## Examples

      iex> get_county!(123)
      %County{}

      iex> get_county!(456)
      ** (Ecto.NoResultsError)

  """
  def get_county!(id), do: Repo.get!(County, id)

  @doc """
  Creates a county.

  ## Examples

      iex> create_county(%{field: value})
      {:ok, %County{}}

      iex> create_county(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_county(attrs \\ %{}) do
    %County{}
    |> County.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates multiple counties.

  If everything is ok, it returns a tuple containing the number of entries stored and any returned result as second element.

  If the changeset detect some errors at some of the counties it will return a list of counties and its respective errors.

  ## Examples

      iex> create_multiple_counties(
              [
                %{
                  id: "1234",
                  name: "County name",
                  district_id: "12"
                },
                ...
              ]
            )
      {:ok, {counties_inserted_quantity, [...]}}

      iex> create_multiple_counties([%{field: value}, %{field: value}, ...])
      {:error, [ %{county: %County{}, errors: [ %Ecto.Changeset{} ]} ]}
  """
  def create_multiple_counties(counties) do
    timestamp =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.truncate(:second)

    counties =
      counties
      |> Enum.map(fn county ->
        %{
          id: county |> Map.get(:id),
          name: county |> Map.get(:name),
          district_id: county |> Map.get(:district_id),
          inserted_at: timestamp,
          updated_at: timestamp
        }
      end)

    errors =
      counties
      |> Enum.map(fn county ->
        errors =
          County.changeset(%County{}, county)
          |> Map.get(:errors)

        %{county: county, errors: errors}
      end)
      |> Enum.filter(fn county -> county.errors != [] end)

    if errors != [] do
      {:error, errors}
    else
      counties_inserted =
        counties
        # 65535 is the maximum of parameters per query; 4 the number of params per row
        |> Enum.chunk_every(trunc(65535 / 4))
        |> Enum.map(fn county -> Repo.insert_all(County, county, on_conflict: :nothing) end)
        |> reduce_multiple_insert_all()

      {:ok, counties_inserted}
    end
  end

  @doc """
  Updates a county.

  ## Examples

      iex> update_county(county, %{field: new_value})
      {:ok, %County{}}

      iex> update_county(county, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_county(%County{} = county, attrs) do
    county
    |> County.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a county.

  ## Examples

      iex> delete_county(county)
      {:ok, %County{}}

      iex> delete_county(county)
      {:error, %Ecto.Changeset{}}

  """
  def delete_county(%County{} = county) do
    Repo.delete(county)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking county changes.

  ## Examples

      iex> change_county(county)
      %Ecto.Changeset{data: %County{}}

  """
  def change_county(%County{} = county, attrs \\ %{}) do
    County.changeset(county, attrs)
  end
end
