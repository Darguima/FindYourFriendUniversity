defmodule FindYourFriendUniversity.ParishesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FindYourFriendUniversity.Parishes` context.
  """

  @doc """
  Generate a parish.
  """
  def parish_fixture(attrs \\ %{}) do
    {:ok, parish} =
      attrs
      |> Enum.into(%{
        id: "some id",
        name: "some name",
        county_id: "some county_id"
      })
      |> FindYourFriendUniversity.Parishes.create_parish()

    parish
  end
end
