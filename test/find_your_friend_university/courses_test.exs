defmodule FindYourFriendUniversity.CoursesTest do
  use FindYourFriendUniversity.DataCase

  alias FindYourFriendUniversity.Courses

  describe "courses" do
    alias FindYourFriendUniversity.Courses.Course

    import FindYourFriendUniversity.CoursesFixtures

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
      valid_attrs = %{id: "some_id", name: "some name"}

      assert {:ok, %Course{} = course} = Courses.create_course(valid_attrs)
      assert course.id == "some_id"
      assert course.name == "some name"
    end

    test "create_course/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Courses.create_course(@invalid_attrs)
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
