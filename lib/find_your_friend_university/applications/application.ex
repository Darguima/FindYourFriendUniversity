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

    |> validate_number(:_11grade, greater_than_or_equal_to: 0, less_than_or_equal_to: 2000)
    |> validate_number(:_12grade, greater_than_or_equal_to: 0, less_than_or_equal_to: 2000)
    |> validate_number(:candidature_grade, greater_than_or_equal_to: 0, less_than_or_equal_to: 2000)
    |> validate_number(:exams_grades, greater_than_or_equal_to: 0, less_than_or_equal_to: 2000)
    |> validate_number(:student_option_number, greater_than_or_equal_to: 0, less_than_or_equal_to: 6)
    |> validate_number(:course_order_num, greater_than_or_equal_to: 0)
    |> validate_number(:phase, greater_than_or_equal_to: 1, less_than_or_equal_to: 3)
    |> validate_number(:year, greater_than_or_equal_to: 2018)

    # To prevent duplicated candidatures - conflicts will be ignored
    |> unique_constraint([:student_id, :year, :phase, :student_option_number, :university_id, :course_id])

    |> foreign_key_constraint(:university_id)
    |> foreign_key_constraint(:course_id)
    |> foreign_key_constraint(:student_id)
  end
end
