defmodule FindYourFriendUniversity.UniversitiesTest do
  use FindYourFriendUniversity.DataCase

  alias FindYourFriendUniversity.Universities

  describe "universities" do
    alias FindYourFriendUniversity.Universities.University

    import FindYourFriendUniversity.UniversitiesFixtures
    import FindYourFriendUniversity.CoursesFixtures

    @invalid_attrs %{id: nil, is_polytechnic: nil, name: nil}

    test "list_universities/0 returns all universities" do
      university = university_fixture()
      assert Universities.list_universities() == [university]
    end

    test "get_university!/1 returns the university with given id" do
      university = university_fixture()
      assert Universities.get_university!(university.id) == university
    end

    test "create_university/1 with valid data creates a university" do
      valid_attrs = %{id: "_id_", is_polytechnic: true, name: "some name"}

      assert {:ok, %University{} = university} = Universities.create_university(valid_attrs)
      assert university.id == "_id_"
      assert university.is_polytechnic == true
      assert university.name == "some name"
    end

    test "create_university/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Universities.create_university(@invalid_attrs)
    end

    test "create_multiple_universities/1 with valid data and no courses associations that creates all universities" do
      universities =
        List.duplicate(%{}, 5)
        |> Enum.map(fn university ->
          university
          |> Map.put(:id, Ecto.UUID.generate() |> String.slice(0..3))
          |> Map.put(:name, Ecto.UUID.generate())
          |> Map.put(:is_polytechnic, false)
        end)

      {:ok, {universities_inserted_qnt, _}, {associations_inserted_qnt, _}} =
        Universities.create_multiple_universities(universities)

      assert universities_inserted_qnt == length(universities)
      assert associations_inserted_qnt == 0

      assert length(Universities.list_universities()) == length(universities)
    end

    test "create_multiple_universities/1 with valid data and with valid courses associations that creates all universities" do
      course = course_fixture()

      universities =
        List.duplicate(%{}, 5)
        |> Enum.map(fn uni ->
          uni
          |> Map.put(:id, Ecto.UUID.generate() |> String.slice(0..3))
          |> Map.put(:name, Ecto.UUID.generate())
          |> Map.put(:is_polytechnic, false)
          |> Map.put(:courses_ids, [course.id])
        end)

      {:ok, {universities_inserted_qnt, _}, {associations_inserted_qnt, _}} =
        Universities.create_multiple_universities(universities)

      assert universities_inserted_qnt == length(universities)
      assert associations_inserted_qnt == length(universities)

      assert length(Universities.list_universities()) == length(universities)
    end

    test "create_multiple_universities/1 with valid data and with invalid courses associations raise a Postgres error" do
      invalid_universities =
        List.duplicate(%{}, 5)
        |> Enum.map(fn uni ->
          uni
          |> Map.put(:id, Ecto.UUID.generate() |> String.slice(0..3))
          |> Map.put(:name, Ecto.UUID.generate())
          |> Map.put(:is_polytechnic, false)
          |> Map.put(:courses_ids, ["_id_"])
        end)

      assert_raise Postgrex.Error, fn ->
        Universities.create_multiple_universities(invalid_universities)
      end
    end

    test "create_multiple_universities/1 with invalid data returns error" do
      invalid_universities =
        List.duplicate(%{}, 5)
        |> Enum.map(fn uni ->
          uni
          |> Map.put(:id, Ecto.UUID.generate() |> String.slice(0..3))
          |> Map.put(:name, nil)
          |> Map.put(:is_polytechnic, nil)
        end)

      assert {:error, _} = Universities.create_multiple_universities(invalid_universities)
    end

    test "update_university/2 with valid data updates the university" do
      university = university_fixture()
      update_attrs = %{is_polytechnic: false, name: "some updated name"}

      assert {:ok, %University{} = university_updated} =
               Universities.update_university(university, update_attrs)

      assert university_updated.id == university.id
      assert university_updated.is_polytechnic == false
      assert university_updated.name == "some updated name"
    end

    test "update_university/2 with invalid data returns error changeset" do
      university = university_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Universities.update_university(university, @invalid_attrs)

      assert university == Universities.get_university!(university.id)
    end

    test "delete_university/1 deletes the university" do
      university = university_fixture()
      assert {:ok, %University{}} = Universities.delete_university(university)
      assert_raise Ecto.NoResultsError, fn -> Universities.get_university!(university.id) end
    end

    test "change_university/1 returns a university changeset" do
      university = university_fixture()
      assert %Ecto.Changeset{} = Universities.change_university(university)
    end
  end
end
