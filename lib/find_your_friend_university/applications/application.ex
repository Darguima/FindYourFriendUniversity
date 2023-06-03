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
    field :university, :id
    field :course, :id
    field :student, :id

    timestamps()
  end

  @doc false
  def changeset(application, attrs) do
    application
    |> cast(attrs, [:course_order_num, :candidature_grade, :exams_grades, :_12grade, :_11grade, :student_option_number, :placed, :year, :phase, :university, :course, :student])
    |> validate_required([:course_order_num, :candidature_grade, :exams_grades, :_12grade, :_11grade, :student_option_number, :placed, :year, :phase, :university, :course, :student])
  end
end
