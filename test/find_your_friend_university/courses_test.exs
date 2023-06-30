defmodule FindYourFriendUniversity.CoursesTest do
  use FindYourFriendUniversity.DataCase

  alias FindYourFriendUniversity.Courses
  alias FindYourFriendUniversity.Courses.Course

  import FindYourFriendUniversity.CoursesFixtures
  import FindYourFriendUniversity.UniversitiesFixtures

  describe "courses" do
    @invalid_attrs %{id: nil, name: nil}

    test "list_courses/0 returns all courses" do
      course = course_fixture()
      assert Courses.list_courses() == [course]
    end

    test "get_course!/1 returns the course with given id" do
      course = course_fixture()
      assert Courses.get_course!(course.id) == course
    end

    test "create_course/1 with valid data creates a course" do
      valid_attrs = %{id: "_id_", name: "some name"}

      assert {:ok, %Course{} = course} = Courses.create_course(valid_attrs)
      assert course.id == "_id_"
      assert course.name == "some name"
    end

    test "create_course/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Courses.create_course(@invalid_attrs)
    end

    test "create_multiple_courses/1 with valid data and no universities associations that creates all courses" do
      courses =
        List.duplicate(%{}, 5)
        |> Enum.map(fn course ->
          course
          |> Map.put(:id, Ecto.UUID.generate() |> String.slice(0..3))
          |> Map.put(:name, Ecto.UUID.generate())
        end)

      {:ok, {courses_inserted_qnt, _}, {associations_inserted_qnt, _}} =
        Courses.create_multiple_courses(courses)

      assert courses_inserted_qnt == length(courses)
      assert associations_inserted_qnt == 0

      assert length(Courses.list_courses()) == length(courses)
    end

    test "create_multiple_courses/1 with valid data and with valid universities associations that creates all courses" do
      university = university_fixture()

      courses =
        List.duplicate(%{}, 5)
        |> Enum.map(fn course ->
          course
          |> Map.put(:id, Ecto.UUID.generate() |> String.slice(0..3))
          |> Map.put(:name, Ecto.UUID.generate())
          |> Map.put(:universities_ids, [university.id])
        end)

      {:ok, {courses_inserted_qnt, _}, {associations_inserted_qnt, _}} =
        Courses.create_multiple_courses(courses)

      assert courses_inserted_qnt == length(courses)
      assert associations_inserted_qnt == length(courses)

      assert length(Courses.list_courses()) == length(courses)
    end

    test "create_multiple_courses/1 with valid data and with invalid universities associations raise a Postgres error" do
      invalid_courses =
        List.duplicate(%{}, 5)
        |> Enum.map(fn course ->
          course
          |> Map.put(:id, Ecto.UUID.generate() |> String.slice(0..3))
          |> Map.put(:name, Ecto.UUID.generate())
          |> Map.put(:universities_ids, ["_id_"])
        end)

      assert_raise Postgrex.Error, fn -> Courses.create_multiple_courses(invalid_courses) end
    end

    test "create_multiple_courses/1 with invalid data returns error" do
      invalid_courses =
        List.duplicate(%{}, 5)
        |> Enum.map(fn course ->
          course
          |> Map.put(:id, Ecto.UUID.generate() |> String.slice(0..3))
          |> Map.put(:name, nil)
        end)

      assert {:error, _} = Courses.create_multiple_courses(invalid_courses)
    end

    test "update_course/2 with valid data updates the course" do
      course = course_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Course{} = course_updated} = Courses.update_course(course, update_attrs)
      assert course_updated.id == course.id
      assert course_updated.name == "some updated name"
    end

    test "update_course/2 with invalid data returns error changeset" do
      course = course_fixture()
      assert {:error, %Ecto.Changeset{}} = Courses.update_course(course, @invalid_attrs)
      assert course == Courses.get_course!(course.id)
    end

    test "delete_course/1 deletes the course" do
      course = course_fixture()
      assert {:ok, %Course{}} = Courses.delete_course(course)
      assert_raise Ecto.NoResultsError, fn -> Courses.get_course!(course.id) end
    end

    test "change_course/1 returns a course changeset" do
      course = course_fixture()
      assert %Ecto.Changeset{} = Courses.change_course(course)
    end
  end
end
