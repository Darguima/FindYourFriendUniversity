defmodule FindYourFriendUniversity.Courses.Course do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, []}
  schema "courses" do
    field :name, :string

    has_many :applications, FindYourFriendUniversity.Applications.Application

    timestamps()
  end

  @doc false
  def changeset(course, attrs) do
    course
    |> cast(attrs, [:id, :name])
    |> validate_required([:id, :name])
  end
end
