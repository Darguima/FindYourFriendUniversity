defmodule FindYourFriendUniversity.StudentsTest do
  use FindYourFriendUniversity.DataCase

  alias FindYourFriendUniversity.Students

  describe "students" do
    alias FindYourFriendUniversity.Students.Student

    import FindYourFriendUniversity.StudentsFixtures

    @invalid_attrs %{civil_id: nil, display_name: nil, id: nil, name: nil}

    test "list_students/0 returns all students" do
      student = student_fixture()
      assert Students.list_students() == [student]
    end

    test "get_student!/1 returns the student with given id" do
      student = student_fixture()
      assert Students.get_student!(student.id) == student
    end

    test "create_student/1 with valid data creates a student" do
      valid_attrs = %{civil_id: "some civil_id", display_name: "some display_name", id: "some_id", name: "some name"}

      assert {:ok, %Student{} = student} = Students.create_student(valid_attrs)
      assert student.civil_id == "some civil_id"
      assert student.display_name == "some display_name"
      assert student.id == "some_id"
      assert student.name == "some name"
    end

    test "create_student/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Students.create_student(@invalid_attrs)
    end

    test "update_student/2 with valid data updates the student" do
      student = student_fixture()
      update_attrs = %{civil_id: "some updated civil_id", display_name: "some updated display_name", name: "some updated name"}

      assert {:ok, %Student{} = student} = Students.update_student(student, update_attrs)
      assert student.civil_id == "some updated civil_id"
      assert student.display_name == "some updated display_name"
      assert student.id == "some_id"
      assert student.name == "some updated name"
    end

    test "update_student/2 with invalid data returns error changeset" do
      student = student_fixture()
      assert {:error, %Ecto.Changeset{}} = Students.update_student(student, @invalid_attrs)
      assert student == Students.get_student!(student.id)
    end

    test "delete_student/1 deletes the student" do
      student = student_fixture()
      assert {:ok, %Student{}} = Students.delete_student(student)
      assert_raise Ecto.NoResultsError, fn -> Students.get_student!(student.id) end
    end

    test "change_student/1 returns a student changeset" do
      student = student_fixture()
      assert %Ecto.Changeset{} = Students.change_student(student)
    end
  end
end
