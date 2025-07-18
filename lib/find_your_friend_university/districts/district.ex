defmodule FindYourFriendUniversity.Districts.District do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, []}
  schema "districts" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(district, attrs) do
    district
    |> cast(attrs, [:id, :name])
    |> validate_required([:id, :name])
    |> validate_length(:id, max: 2)
    |> unique_constraint(:id, name: :districts_pkey)
    |> unique_constraint(:name, name: :districts_name_index)
  end
end
