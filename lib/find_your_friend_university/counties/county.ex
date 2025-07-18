defmodule FindYourFriendUniversity.Counties.County do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, []}
  schema "counties" do
    field :name, :string
    field :district_id, :string

    timestamps()
  end

  @doc false
  def changeset(county, attrs) do
    county
    |> cast(attrs, [:id, :name, :district_id])
    |> validate_required([:id, :name, :district_id])
  end
end
