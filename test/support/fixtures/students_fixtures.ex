defmodule FindYourFriendUniversity.StudentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FindYourFriendUniversity.Students` context.
  """

  @doc """
  Generate a student.
  """
  def student_fixture(attrs \\ %{}) do
    {:ok, student} =
      attrs
      |> Enum.into(%{
        id: Ecto.UUID.generate,
        civil_id: "some civil_id",
        display_name: "some display_name",
        name: "some name"
      })
      |> FindYourFriendUniversity.Students.create_student()

    student
  end
end
