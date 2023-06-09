defmodule FindYourFriendUniversity.CoursesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FindYourFriendUniversity.Courses` context.
  """

  @doc """
  Generate a course.
  """
  def course_fixture(attrs \\ %{}) do
    {:ok, course} =
      attrs
      |> Enum.into(%{
        name: "some name",
        id: 42
      })
      |> FindYourFriendUniversity.Courses.create_course()

    course
  end
end
