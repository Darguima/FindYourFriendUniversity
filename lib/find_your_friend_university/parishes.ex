defmodule FindYourFriendUniversity.Parishes do
  @moduledoc """
  The Parishes context.
  """

  import Ecto.Query, warn: false
  alias FindYourFriendUniversity.Repo
  import FindYourFriendUniversity.Helpers

  alias FindYourFriendUniversity.Parishes.Parish

  @doc """
  Returns the list of parishes.

  ## Examples

      iex> list_parishes()
      [%Parish{}, ...]

  """
  def list_parishes do
    Repo.all(Parish)
  end

  @doc """
  Gets a single parish.

  Raises `Ecto.NoResultsError` if the Parish does not exist.

  ## Examples

      iex> get_parish!(123)
      %Parish{}

      iex> get_parish!(456)
      ** (Ecto.NoResultsError)

  """
  def get_parish!(id), do: Repo.get!(Parish, id)

  @doc """
  Creates a parish.

  ## Examples

      iex> create_parish(%{field: value})
      {:ok, %Parish{}}

      iex> create_parish(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_parish(attrs \\ %{}) do
    %Parish{}
    |> Parish.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates multiple parishes.

  If everything is ok, it returns a tuple containing the number of entries stored and any returned result as second element.

  If the changeset detect some errors at some of the parishes it will return a list of parishes and its respective errors.

  ## Examples

      iex> create_multiple_parishes(
              [
                %{
                  id: "1234",
                  name: "Parish name",
                  county_id: "12"
                },
                ...
              ]
            )
      {:ok, {parishes_inserted_quantity, [...]}}

      iex> create_multiple_parishes([%{field: value}, %{field: value}, ...])
      {:error, [ %{parish: %Parish{}, errors: [ %Ecto.Changeset{} ]} ]}
  """
  def create_multiple_parishes(parishes) do
    timestamp =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.truncate(:second)

    parishes =
      parishes
      |> Enum.map(fn parish ->
        %{
          id: parish |> Map.get(:id),
          name: parish |> Map.get(:name),
          county_id: parish |> Map.get(:county_id),
          inserted_at: timestamp,
          updated_at: timestamp
        }
      end)

    errors =
      parishes
      |> Enum.map(fn parish ->
        errors =
          Parish.changeset(%Parish{}, parish)
          |> Map.get(:errors)

        %{parish: parish, errors: errors}
      end)
      |> Enum.filter(fn parish -> parish.errors != [] end)

    if errors != [] do
      {:error, errors}
    else
      parishes_inserted =
        parishes
        # 65535 is the maximum of parameters per query; 5 the number of params per row
        |> Enum.chunk_every(trunc(65535 / 5))
        |> Enum.map(fn parish -> Repo.insert_all(Parish, parish, on_conflict: :nothing) end)
        |> reduce_multiple_insert_all()

      {:ok, parishes_inserted}
    end
  end

  @doc """
  Updates a parish.

  ## Examples

      iex> update_parish(parish, %{field: new_value})
      {:ok, %Parish{}}

      iex> update_parish(parish, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_parish(%Parish{} = parish, attrs) do
    parish
    |> Parish.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a parish.

  ## Examples

      iex> delete_parish(parish)
      {:ok, %Parish{}}

      iex> delete_parish(parish)
      {:error, %Ecto.Changeset{}}

  """
  def delete_parish(%Parish{} = parish) do
    Repo.delete(parish)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking parish changes.

  ## Examples

      iex> change_parish(parish)
      %Ecto.Changeset{data: %Parish{}}

  """
  def change_parish(%Parish{} = parish, attrs \\ %{}) do
    Parish.changeset(parish, attrs)
  end
end
