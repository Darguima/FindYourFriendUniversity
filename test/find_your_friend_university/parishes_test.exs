defmodule FindYourFriendUniversity.ParishesTest do
  use FindYourFriendUniversity.DataCase

  alias FindYourFriendUniversity.Parishes

  describe "parishes" do
    alias FindYourFriendUniversity.Parishes.Parish

    import FindYourFriendUniversity.ParishesFixtures

    @invalid_attrs %{id: nil, name: nil, county_id: nil}

    test "list_parishes/0 returns all parishes" do
      parish = parish_fixture()
      assert Parishes.list_parishes() == [parish]
    end

    test "get_parish!/1 returns the parish with given id" do
      parish = parish_fixture()
      assert Parishes.get_parish!(parish.id) == parish
    end

    test "create_parish/1 with valid data creates a parish" do
      valid_attrs = %{id: "some id", name: "some name", county_id: "some county_id"}

      assert {:ok, %Parish{} = parish} = Parishes.create_parish(valid_attrs)
      assert parish.id == "some id"
      assert parish.name == "some name"
      assert parish.county_id == "some county_id"
    end

    test "create_parish/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Parishes.create_parish(@invalid_attrs)
    end

    test "update_parish/2 with valid data updates the parish" do
      parish = parish_fixture()
      update_attrs = %{id: "some updated id", name: "some updated name", county_id: "some updated county_id"}

      assert {:ok, %Parish{} = parish} = Parishes.update_parish(parish, update_attrs)
      assert parish.id == "some updated id"
      assert parish.name == "some updated name"
      assert parish.county_id == "some updated county_id"
    end

    test "update_parish/2 with invalid data returns error changeset" do
      parish = parish_fixture()
      assert {:error, %Ecto.Changeset{}} = Parishes.update_parish(parish, @invalid_attrs)
      assert parish == Parishes.get_parish!(parish.id)
    end

    test "delete_parish/1 deletes the parish" do
      parish = parish_fixture()
      assert {:ok, %Parish{}} = Parishes.delete_parish(parish)
      assert_raise Ecto.NoResultsError, fn -> Parishes.get_parish!(parish.id) end
    end

    test "change_parish/1 returns a parish changeset" do
      parish = parish_fixture()
      assert %Ecto.Changeset{} = Parishes.change_parish(parish)
    end
  end
end
