defmodule FindYourFriendUniversity.Universities.University do
  use Ecto.Schema
  import Ecto.Changeset

  schema "universities" do
    field :name, :string
    field :code_id, :integer
    field :is_polytechnic, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(university, attrs) do
    university
    |> cast(attrs, [:name, :code_id, :is_polytechnic])
    |> validate_required([:name, :code_id, :is_polytechnic])
  end
end
