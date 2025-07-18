defmodule FindYourFriendUniversity.Parishes do
  @moduledoc """
  The Parishes context.
  """

  import Ecto.Query, warn: false
  alias FindYourFriendUniversity.Repo

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
