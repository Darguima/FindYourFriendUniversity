defmodule FindYourFriendUniversity.Applications.Application do
  use Ecto.Schema
  import Ecto.Changeset

  schema "applications" do
    field :_11grade, :integer
    field :_12grade, :integer
    field :candidature_grade, :integer
    field :course_order_num, :integer
    field :exams_grades, :integer
    field :phase, :integer
    field :placed, :boolean, default: false
    field :student_option_number, :integer
    field :year, :integer

    belongs_to :university, FindYourFriendUniversity.Universities.University, type: :string
    belongs_to :course, FindYourFriendUniversity.Courses.Course, type: :string
    belongs_to :student, FindYourFriendUniversity.Students.Student, type: :string

    timestamps()
  end

  @doc false
  def changeset(application, attrs) do
    application
    |> cast(attrs, [:course_order_num, :candidature_grade, :exams_grades, :_12grade, :_11grade, :student_option_number, :placed, :year, :phase, :university_id, :course_id, :student_id])
    |> validate_required([:course_order_num, :candidature_grade, :exams_grades, :_12grade, :_11grade, :student_option_number, :placed, :year, :phase, :university_id, :course_id, :student_id])
    |> foreign_key_constraint(:university_id)
    |> foreign_key_constraint(:course_id)
    |> foreign_key_constraint(:student_id)
  end
end
