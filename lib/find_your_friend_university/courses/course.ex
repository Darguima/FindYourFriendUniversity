defmodule FindYourFriendUniversity.Courses.Course do
  use Ecto.Schema
  import Ecto.Changeset
  alias FindYourFriendUniversity.Universities
  alias FindYourFriendUniversity.Universities.University

  @primary_key {:id, :string, []} # Some codes have the letter L
  schema "courses" do
    field :name, :string
    many_to_many :universities, University, join_through: "universities_courses", on_replace: :delete
    has_many :applications, FindYourFriendUniversity.Applications.Application, on_delete: :delete_all

    timestamps()
  end

  defp put_assoc_universities(changeset, attrs) do
    uni_ids =
      (Map.get(attrs, "universities_ids", []) ++ Map.get(attrs, :universities_ids, []))
      |> Universities.get_universities()

    Ecto.Changeset.put_assoc(changeset, :universities, uni_ids)
  end

  @doc false
  def changeset(course, attrs) do
    course
    |> cast(attrs, [:name, :id])
    |> validate_length(:id, is: 4)
    |> validate_required([:name, :id])
    |> put_assoc_universities(attrs)
  end
end
