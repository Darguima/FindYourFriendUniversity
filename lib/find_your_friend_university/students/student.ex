defmodule FindYourFriendUniversity.Students.Student do
  use Ecto.Schema
  import Ecto.Changeset

  schema "students" do
    field :name, :string
    field :display_name, :string
    field :civil_id, :string

    timestamps()
  end

  @doc false
  def changeset(student, attrs) do
    student
    |> cast(attrs, [:name, :display_name, :civil_id])
    |> validate_required([:name, :display_name, :civil_id])
  end
end
