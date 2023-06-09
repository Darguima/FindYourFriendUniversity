defmodule FindYourFriendUniversity.UniversitiesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FindYourFriendUniversity.Universities` context.
  """

  @doc """
  Generate a university.
  """
  def university_fixture(attrs \\ %{}) do
    {:ok, university} =
      attrs
      |> Enum.into(%{
        name: "some name",
        id: 42,
        is_polytechnic: true
      })
      |> FindYourFriendUniversity.Universities.create_university()

    university
  end
end
