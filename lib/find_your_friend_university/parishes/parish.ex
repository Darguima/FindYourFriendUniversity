defmodule FindYourFriendUniversity.Parishes.Parish do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, []}
  schema "parishes" do
    field :name, :string
    field :county_id, :string

    timestamps()
  end

  @doc false
  def changeset(parish, attrs) do
    parish
    |> cast(attrs, [:id, :name, :county_id])
    |> validate_required([:id, :name, :county_id])
  end
end
