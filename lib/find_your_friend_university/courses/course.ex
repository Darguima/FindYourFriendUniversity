defmodule FindYourFriendUniversity.Courses.Course do
  use Ecto.Schema
  import Ecto.Changeset

  schema "courses" do
    field :name, :string
    field :code_id, :integer

    timestamps()
  end

  @doc false
  def changeset(course, attrs) do
    course
    |> cast(attrs, [:name, :code_id])
    |> validate_required([:name, :code_id])
  end
end
