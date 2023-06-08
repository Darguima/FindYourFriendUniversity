defmodule FindYourFriendUniversity.Courses.Course do
  use Ecto.Schema
  import Ecto.Changeset
  alias FindYourFriendUniversity.Universities
  alias FindYourFriendUniversity.Universities.University

  schema "courses" do
    field :name, :string
    field :code_id, :string # Some codes have the letter L
    many_to_many :universities, University, join_through: "universities_courses", on_replace: :delete

    timestamps()
  end

  defp put_assoc_universities(changeset, attrs) do
    universities =
      (Map.get(attrs, "universities_ids", []) ++ Map.get(attrs, :universities_ids, []))
      |> Universities.get_universities()

    Ecto.Changeset.put_assoc(changeset, :universities, universities)
  end

  @doc false
  def changeset(course, attrs) do
    course
    |> cast(attrs, [:name, :code_id])
    |> validate_length(:code_id, is: 4)
    |> validate_required([:name, :code_id])
    |> put_assoc_universities(attrs)
  end
end
