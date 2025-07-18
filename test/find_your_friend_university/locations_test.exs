defmodule FindYourFriendUniversity.LocationsTest do
  use FindYourFriendUniversity.DataCase

  alias FindYourFriendUniversity.Locations

  describe "locations" do
    alias FindYourFriendUniversity.Locations.Location

    import FindYourFriendUniversity.LocationsFixtures

    @invalid_attrs %{name: nil, civil_id: nil, parish_id: nil}

    test "list_locations/0 returns all locations" do
      location = location_fixture()
      assert Locations.list_locations() == [location]
    end

    test "get_location!/1 returns the location with given id" do
      location = location_fixture()
      assert Locations.get_location!(location.id) == location
    end

    test "create_location/1 with valid data creates a location" do
      valid_attrs = %{name: "some name", civil_id: "some civil_id", parish_id: "some parish_id"}

      assert {:ok, %Location{} = location} = Locations.create_location(valid_attrs)
      assert location.name == "some name"
      assert location.civil_id == "some civil_id"
      assert location.parish_id == "some parish_id"
    end

    test "create_location/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Locations.create_location(@invalid_attrs)
    end

    test "update_location/2 with valid data updates the location" do
      location = location_fixture()
      update_attrs = %{name: "some updated name", civil_id: "some updated civil_id", parish_id: "some updated parish_id"}

      assert {:ok, %Location{} = location} = Locations.update_location(location, update_attrs)
      assert location.name == "some updated name"
      assert location.civil_id == "some updated civil_id"
      assert location.parish_id == "some updated parish_id"
    end

    test "update_location/2 with invalid data returns error changeset" do
      location = location_fixture()
      assert {:error, %Ecto.Changeset{}} = Locations.update_location(location, @invalid_attrs)
      assert location == Locations.get_location!(location.id)
    end

    test "delete_location/1 deletes the location" do
      location = location_fixture()
      assert {:ok, %Location{}} = Locations.delete_location(location)
      assert_raise Ecto.NoResultsError, fn -> Locations.get_location!(location.id) end
    end

    test "change_location/1 returns a location changeset" do
      location = location_fixture()
      assert %Ecto.Changeset{} = Locations.change_location(location)
    end
  end
end
