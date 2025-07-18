defmodule FindYourFriendUniversity.LocationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FindYourFriendUniversity.Locations` context.
  """

  @doc """
  Generate a location.
  """
  def location_fixture(attrs \\ %{}) do
    {:ok, location} =
      attrs
      |> Enum.into(%{
        name: "some name",
        civil_id: "some civil_id",
        parish_id: "some parish_id"
      })
      |> FindYourFriendUniversity.Locations.create_location()

    location
  end
end
