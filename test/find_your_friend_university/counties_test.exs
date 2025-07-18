defmodule FindYourFriendUniversity.CountiesTest do
  use FindYourFriendUniversity.DataCase

  alias FindYourFriendUniversity.Counties

  describe "counties" do
    alias FindYourFriendUniversity.Counties.County

    import FindYourFriendUniversity.CountiesFixtures

    @invalid_attrs %{id: nil, name: nil, district_id: nil}

    test "list_counties/0 returns all counties" do
      county = county_fixture()
      assert Counties.list_counties() == [county]
    end

    test "get_county!/1 returns the county with given id" do
      county = county_fixture()
      assert Counties.get_county!(county.id) == county
    end

    test "create_county/1 with valid data creates a county" do
      valid_attrs = %{id: "some id", name: "some name", district_id: "some district_id"}

      assert {:ok, %County{} = county} = Counties.create_county(valid_attrs)
      assert county.id == "some id"
      assert county.name == "some name"
      assert county.district_id == "some district_id"
    end

    test "create_county/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Counties.create_county(@invalid_attrs)
    end

    test "update_county/2 with valid data updates the county" do
      county = county_fixture()
      update_attrs = %{id: "some updated id", name: "some updated name", district_id: "some updated district_id"}

      assert {:ok, %County{} = county} = Counties.update_county(county, update_attrs)
      assert county.id == "some updated id"
      assert county.name == "some updated name"
      assert county.district_id == "some updated district_id"
    end

    test "update_county/2 with invalid data returns error changeset" do
      county = county_fixture()
      assert {:error, %Ecto.Changeset{}} = Counties.update_county(county, @invalid_attrs)
      assert county == Counties.get_county!(county.id)
    end

    test "delete_county/1 deletes the county" do
      county = county_fixture()
      assert {:ok, %County{}} = Counties.delete_county(county)
      assert_raise Ecto.NoResultsError, fn -> Counties.get_county!(county.id) end
    end

    test "change_county/1 returns a county changeset" do
      county = county_fixture()
      assert %Ecto.Changeset{} = Counties.change_county(county)
    end
  end
end
