defmodule FindYourFriendUniversity.Locations.Location do
  use Ecto.Schema
  import Ecto.Changeset

  schema "locations" do
    field :name, :string
    field :civil_id, :string
    field :year, :string

    belongs_to :parish, FindYourFriendUniversity.Parishes.Parish, type: :string

    timestamps()
  end

  @doc false
  def changeset(location, attrs) do
    location
    |> cast(attrs, [:name, :civil_id, :parish_id, :year])
    |> validate_required([:name, :civil_id, :parish_id, :year])

    |> validate_length(:civil_id, greater_than_or_equal_to: 7, less_than_or_equal_to: 8)
    |> validate_length(:year, is: 4)
    |> unique_constraint([:name, :civil_id, :parish_id, :year])

    |> foreign_key_constraint(:parish_id)
  end
end
