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
        id: Ecto.UUID.generate() |> String.slice(0..3),
        is_polytechnic: true,
        name: "some name"
      })
      |> FindYourFriendUniversity.Universities.create_university()

    university
  end
end
