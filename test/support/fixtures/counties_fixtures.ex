defmodule FindYourFriendUniversity.CountiesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FindYourFriendUniversity.Counties` context.
  """

  @doc """
  Generate a county.
  """
  def county_fixture(attrs \\ %{}) do
    {:ok, county} =
      attrs
      |> Enum.into(%{
        id: "some id",
        name: "some name",
        district_id: "some district_id"
      })
      |> FindYourFriendUniversity.Counties.create_county()

    county
  end
end
