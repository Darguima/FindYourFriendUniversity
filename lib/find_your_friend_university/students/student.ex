defmodule FindYourFriendUniversity.Students.Student do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, []} # civil_id <> display_name
  schema "students" do
    field :name, :string
    field :display_name, :string
    field :civil_id, :string
    has_many :applications, FindYourFriendUniversity.Applications.Application, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(student, attrs) do
    student
    |> cast(attrs, [:id, :name, :display_name, :civil_id])
    |> validate_required([:id, :name, :display_name, :civil_id])
  end
end
