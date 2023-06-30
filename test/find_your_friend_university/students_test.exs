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
      valid_attrs = %{
        civil_id: "civil_id",
        display_name: "some display_name",
        id: "_id_",
        name: "some name"
      }

      assert {:ok, %Student{} = student} = Students.create_student(valid_attrs)
      assert student.civil_id == "civil_id"
      assert student.display_name == "some display_name"
      assert student.id == "_id_"
      assert student.name == "some name"
    end

    test "create_student/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Students.create_student(@invalid_attrs)
    end

    test "create_multiple_students/1 with valid data that creates all students" do
      students =
        List.duplicate(%{}, 5)
        |> Enum.map(fn student ->
          student
          |> Map.put(:id, Ecto.UUID.generate())
          |> Map.put(:name, Ecto.UUID.generate())
          |> Map.put(:display_name, Ecto.UUID.generate())
          |> Map.put(:civil_id, Ecto.UUID.generate() |> String.slice(0..7))
        end)

      {:ok, {students_inserted_qnt, _}} = Students.create_multiple_students(students)

      assert students_inserted_qnt == length(students)
      assert length(Students.list_students()) == length(students)
    end

    test "create_multiple_students/1 with invalid data returns error" do
      invalid_courses =
        List.duplicate(%{}, 5)
        |> Enum.map(fn course ->
          course
          |> Map.put(:id, nil)
          |> Map.put(:name, nil)
          |> Map.put(:display_name, nil)
          |> Map.put(:civil_id, nil)
        end)

      assert {:error, _} = Students.create_multiple_students(invalid_courses)
    end

    test "update_student/2 with valid data updates the student" do
      student = student_fixture()

      update_attrs = %{
        civil_id: "civil_id",
        display_name: "some updated display_name",
        name: "some updated name"
      }

      assert {:ok, %Student{} = student_updated} = Students.update_student(student, update_attrs)
      assert student_updated.id == student.id
      assert student_updated.civil_id == "civil_id"
      assert student_updated.display_name == "some updated display_name"
      assert student_updated.name == "some updated name"
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
