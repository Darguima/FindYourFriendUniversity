defmodule FindYourFriendUniversity.DistrictsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FindYourFriendUniversity.Districts` context.
  """

  @doc """
  Generate a district.
  """
  def district_fixture(attrs \\ %{}) do
    {:ok, district} =
      attrs
      |> Enum.into(%{
        id: "some id",
        name: "some name"
      })
      |> FindYourFriendUniversity.Districts.create_district()

    district
  end
end
