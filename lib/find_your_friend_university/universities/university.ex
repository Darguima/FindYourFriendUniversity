defmodule FindYourFriendUniversity.Universities.University do
  use Ecto.Schema
  import Ecto.Changeset
  alias FindYourFriendUniversity.Courses.Course

  @primary_key {:id, :string, []}
  schema "universities" do
    field(:is_polytechnic, :boolean, default: false)
    field(:name, :string)

    has_many :applications, FindYourFriendUniversity.Applications.Application
    many_to_many :courses, Course, join_through: "universities_courses"

    timestamps()
  end

  defp put_assoc_courses(changeset, []) do
    changeset
  end

  defp put_assoc_courses(changeset, courses) do
    put_assoc(changeset, :courses, courses)
  end

  @doc false
  def changeset(university, attrs) do
    courses =
      attrs
      |> Map.get(:courses, [])

    university
    |> cast(attrs, [:id, :name, :is_polytechnic])
    |> validate_required([:id, :name, :is_polytechnic])
    |> validate_length(:id, is: 4)
    |> unique_constraint(:id, name: :universities_pkey)
    |> put_assoc_courses(courses)
  end
end
