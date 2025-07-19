defmodule FindYourFriendUniversity.Parishes.Parish do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, []}
  schema "parishes" do
    field :name, :string

    belongs_to :county, FindYourFriendUniversity.Counties.County, type: :string

    timestamps()
  end

  @doc false
  def changeset(parish, attrs) do
    parish
    |> cast(attrs, [:id, :name, :county_id])
    |> validate_required([:id, :name, :county_id])

    |> validate_length(:id, max: 4)
    |> unique_constraint(:id, name: :parishes_pkey)
    |> unique_constraint([:county_id, :name], name: :parishes_county_id_name_index)

    |> foreign_key_constraint(:county_id)
  end
end
