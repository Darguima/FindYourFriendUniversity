defmodule FindYourFriendUniversity.CoursesTest do
  use FindYourFriendUniversity.DataCase

  alias FindYourFriendUniversity.Courses

  describe "courses" do
    alias FindYourFriendUniversity.Courses.Course

    import FindYourFriendUniversity.CoursesFixtures

    @invalid_attrs %{name: nil, id: nil}

    test "list_courses/0 returns all courses" do
      course = course_fixture()
      assert Courses.list_courses() == [course]
    end

    test "get_course!/1 returns the course with given id" do
      course = course_fixture()
      assert Courses.get_course!(course.id) == course
    end

    test "create_course/1 with valid data creates a course" do
      valid_attrs = %{name: "some name", id: 42}

      assert {:ok, %Course{} = course} = Courses.create_course(valid_attrs)
      assert course.name == "some name"
      assert course.id == 42
    end

    test "create_course/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Courses.create_course(@invalid_attrs)
    end

    test "update_course/2 with valid data updates the course" do
      course = course_fixture()
      update_attrs = %{name: "some updated name", id: 43}

      assert {:ok, %Course{} = course} = Courses.update_course(course, update_attrs)
      assert course.name == "some updated name"
      assert course.id == 43
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
