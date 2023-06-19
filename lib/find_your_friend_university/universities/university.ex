defmodule FindYourFriendUniversity.Universities.University do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, []}
  schema "universities" do
    field(:is_polytechnic, :boolean, default: false)
    field(:name, :string)

    has_many :applications, FindYourFriendUniversity.Applications.Application

    timestamps()
  end

  @doc false
  def changeset(university, attrs) do
    university
    |> cast(attrs, [:id, :name, :is_polytechnic])
    |> validate_required([:id, :name, :is_polytechnic])
  end
end
