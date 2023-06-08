defmodule FindYourFriendUniversity.Universities.University do
  use Ecto.Schema
  import Ecto.Changeset
  alias FindYourFriendUniversity.Courses
  alias FindYourFriendUniversity.Courses.Course

  schema "universities" do
    field :name, :string
    field :code_id, :string # Just because in courses codes need be string
    field :is_polytechnic, :boolean, default: false
    many_to_many :courses, Course, join_through: "universities_courses", on_replace: :delete

    timestamps()
  end

  defp put_assoc_courses(changeset, attrs) do
    courses =
      (Map.get(attrs, "courses_ids", []) ++ Map.get(attrs, :courses_ids, []))
      |> Courses.get_courses()

    Ecto.Changeset.put_assoc(changeset, :courses, courses)
  end

  @doc false
  def changeset(university, attrs) do
    university
    |> cast(attrs, [:name, :code_id, :is_polytechnic])
    |> validate_length(:code_id, is: 4)
    |> validate_required([:name, :code_id, :is_polytechnic])
    |> put_assoc_courses(attrs)
  end
end
