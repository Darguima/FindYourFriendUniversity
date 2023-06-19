defmodule FindYourFriendUniversity.Students.Student do
  use Ecto.Schema
  import Ecto.Changeset

  # id = civil_id <> display_name
  @primary_key {:id, :string, []}
  schema "students" do
    field(:civil_id, :string)
    field(:display_name, :string)
    field(:name, :string)

    has_many :applications, FindYourFriendUniversity.Applications.Application

    timestamps()
  end

  @doc false
  def changeset(student, attrs) do
    student
    |> cast(attrs, [:id, :name, :display_name, :civil_id])
    |> validate_required([:id, :name, :display_name, :civil_id])
  end
end
