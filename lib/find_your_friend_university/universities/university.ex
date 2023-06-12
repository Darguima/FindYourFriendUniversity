defmodule FindYourFriendUniversity.Universities.University do
  use Ecto.Schema
  import Ecto.Changeset
  alias FindYourFriendUniversity.Courses
  alias FindYourFriendUniversity.Courses.Course

  @primary_key {:id, :string, []} # Some codes have the letter L
  schema "universities" do
    field :name, :string
    field :is_polytechnic, :boolean, default: false
    many_to_many :courses, Course, join_through: "universities_courses", on_replace: :delete
    has_many :applications, FindYourFriendUniversity.Applications.Application, on_delete: :delete_all

    timestamps()
  end

  defp put_assoc_courses(changeset, attrs) do
    courses_ids =
      (Map.get(attrs, "courses_ids", []) ++ Map.get(attrs, :courses_ids, []))
      |> Courses.get_courses()

    Ecto.Changeset.put_assoc(changeset, :courses, courses_ids)
  end

  @doc false
  def changeset(university, attrs) do
    university
    |> cast(attrs, [:name, :id, :is_polytechnic])
    |> validate_length(:id, is: 4)
    |> validate_required([:name, :id, :is_polytechnic])
    |> put_assoc_courses(attrs)
  end
end
