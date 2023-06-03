defmodule FindYourFriendUniversity.ApplicationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FindYourFriendUniversity.Applications` context.
  """

  @doc """
  Generate a application.
  """
  def application_fixture(attrs \\ %{}) do
    {:ok, application} =
      attrs
      |> Enum.into(%{
        _11grade: 42,
        _12grade: 42,
        candidature_grade: 42,
        course_order_num: 42,
        exams_grades: 42,
        phase: 42,
        placed: true,
        student_option_number: 42,
        year: 42
      })
      |> FindYourFriendUniversity.Applications.create_application()

    application
  end
end
