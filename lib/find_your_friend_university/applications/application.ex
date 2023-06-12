defmodule FindYourFriendUniversity.Applications.Application do
  alias FindYourFriendUniversity.Universities
  alias FindYourFriendUniversity.Courses
  alias FindYourFriendUniversity.Students
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

    belongs_to :university, FindYourFriendUniversity.Universities.University, on_replace: :nilify, type: :string
    belongs_to :course, FindYourFriendUniversity.Courses.Course, on_replace: :nilify, type: :string
    belongs_to :student, FindYourFriendUniversity.Students.Student, on_replace: :nilify, type: :string

    timestamps()
  end

  defp put_assoc_university(changeset, attrs) do
    if is_nil(attrs["university"]) && is_nil(attrs[:university]) do
      changeset
    else
      university = Universities.get_university!(attrs["university"] || attrs[:university])
      Ecto.Changeset.put_assoc(changeset, :university, university)
    end
  end

  defp put_assoc_course(changeset, attrs) do
    if is_nil(attrs["course"]) && is_nil(attrs[:course]) do
      changeset
    else
      course = Courses.get_course!(attrs["course"] || attrs[:course])
      Ecto.Changeset.put_assoc(changeset, :course, course)
    end
  end

  defp put_assoc_student(changeset, attrs) do
    if is_nil(attrs["student"]) && is_nil(attrs[:student]) do
      changeset
    else
      student = Students.get_student!(attrs["student"] || attrs[:student])
      Ecto.Changeset.put_assoc(changeset, :student, student)
    end
  end

  @doc false
  def changeset(application, attrs) do
    application
    |> cast(attrs, [:course_order_num, :candidature_grade, :exams_grades, :_12grade, :_11grade, :student_option_number, :placed, :year, :phase])
    |> validate_required([:course_order_num, :candidature_grade, :exams_grades, :_12grade, :_11grade, :student_option_number, :placed, :year, :phase])
    |> put_assoc_university(attrs)
    |> put_assoc_course(attrs)
    |> put_assoc_student(attrs)
  end
end
