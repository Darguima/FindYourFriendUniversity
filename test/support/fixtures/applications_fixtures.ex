defmodule FindYourFriendUniversity.ApplicationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FindYourFriendUniversity.Applications` context.
  """

  import FindYourFriendUniversity.UniversitiesFixtures
  import FindYourFriendUniversity.CoursesFixtures
  import FindYourFriendUniversity.StudentsFixtures

  @doc """
  Generate a application.
  """
  def application_fixture(attrs \\ %{}) do
    university = university_fixture()
    course = course_fixture()
    student = student_fixture()

    {:ok, application} =
      attrs
      |> Enum.into(%{
        _11grade: 18,
        _12grade: 13,
        candidature_grade: 16,
        course_order_num: 98,
        exams_grades: 15,
        phase: 2,
        placed: true,
        student_option_number: 2,
        year: 2019,
        university_id: university.id,
        course_id: course.id,
        student_id: student.id
      })
      |> FindYourFriendUniversity.Applications.create_application()

    application
  end
end
