defmodule FindYourFriendUniversity.Districts do
  @moduledoc """
  The Districts context.
  """

  import Ecto.Query, warn: false
  import FindYourFriendUniversity.Helpers

  alias FindYourFriendUniversity.Repo

  alias FindYourFriendUniversity.Districts.District

  @doc """
  Returns the list of districts.

  ## Examples

      iex> list_districts()
      [%District{}, ...]

  """
  def list_districts do
    Repo.all(District)
  end

  @doc """
  Gets a single district.

  Raises `Ecto.NoResultsError` if the District does not exist.

  ## Examples

      iex> get_district!(123)
      %District{}

      iex> get_district!(456)
      ** (Ecto.NoResultsError)

  """
  def get_district!(id), do: Repo.get!(District, id)

  @doc """
  Creates a district.

  ## Examples

      iex> create_district(%{field: value})
      {:ok, %District{}}

      iex> create_district(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_district(attrs \\ %{}) do
    %District{}
    |> District.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates multiple districts.

  If everything is ok, it returns a tuple containing the number of entries stored and any returned result as second element.

  If the changeset detect some errors at some of the districts it will return a list of districts and its respective errors.

  ## Examples

      iex> create_multiple_districts(
              [
                %{
                  id: "1234",
                  name: "District name",
                },
                ...
              ]
            )
      {:ok, {districts_inserted_quantity, [...]}}

      iex> create_multiple_districts([%{field: value}, %{field: value}, ...])
      {:error, [ %{district: %District{}, errors: [ %Ecto.Changeset{} ]} ]}
  """
  def create_multiple_districts(districts) do
    timestamp =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.truncate(:second)

    districts =
      districts
      |> Enum.map(fn district ->
        %{
          id: district |> Map.get(:id),
          name: district |> Map.get(:name),
          inserted_at: timestamp,
          updated_at: timestamp
        }
      end)

    errors =
      districts
      |> Enum.map(fn district ->
        errors =
          District.changeset(%District{}, district)
          |> Map.get(:errors)

        %{district: district, errors: errors}
      end)
      |> Enum.filter(fn district -> district.errors != [] end)

    if errors != [] do
      {:error, errors}
    else
      districts_inserted =
        districts
        # 65535 is the maximum of parameters per query; 4 the number of params per row
        |> Enum.chunk_every(trunc(65535 / 4))
        |> Enum.map(fn district -> Repo.insert_all(District, district, on_conflict: :nothing) end)
        |> reduce_multiple_insert_all()

      {:ok, districts_inserted}
    end
  end


  @doc """
  Updates a district.

  ## Examples

      iex> update_district(district, %{field: new_value})
      {:ok, %District{}}

      iex> update_district(district, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_district(%District{} = district, attrs) do
    district
    |> District.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a district.

  ## Examples

      iex> delete_district(district)
      {:ok, %District{}}

      iex> delete_district(district)
      {:error, %Ecto.Changeset{}}

  """
  def delete_district(%District{} = district) do
    Repo.delete(district)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking district changes.

  ## Examples

      iex> change_district(district)
      %Ecto.Changeset{data: %District{}}

  """
  def change_district(%District{} = district, attrs \\ %{}) do
    District.changeset(district, attrs)
  end
end
