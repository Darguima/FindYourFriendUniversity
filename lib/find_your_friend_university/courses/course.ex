defmodule FindYourFriendUniversity.Courses.Course do
  use Ecto.Schema
  import Ecto.Changeset
  alias FindYourFriendUniversity.Universities.University

  @primary_key {:id, :string, []}
  schema "courses" do
    field(:name, :string)

    has_many(:applications, FindYourFriendUniversity.Applications.Application)
    many_to_many(:universities, University, join_through: "universities_courses")

    timestamps()
  end

  defp put_assoc_universities(changeset, []) do
    changeset
  end

  defp put_assoc_universities(changeset, universities) do
    put_assoc(changeset, :universities, universities)
  end

  @doc false
  def changeset(course, attrs) do
    universities = attrs
    |> Map.get(:universities, [])

    course
    |> cast(attrs, [:id, :name])
    |> validate_required([:id, :name])
    |> put_assoc_universities(universities)
  end
end
