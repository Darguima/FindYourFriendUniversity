defmodule FindYourFriendUniversity.ApplicationsTest do
  use FindYourFriendUniversity.DataCase

  alias FindYourFriendUniversity.Applications

  describe "applications" do
    alias FindYourFriendUniversity.Applications.Application

    import FindYourFriendUniversity.ApplicationsFixtures

    @invalid_attrs %{_11grade: nil, _12grade: nil, candidature_grade: nil, course_order_num: nil, exams_grades: nil, phase: nil, placed: nil, student_option_number: nil, year: nil}

    test "list_applications/0 returns all applications" do
      application = application_fixture()
      assert Applications.list_applications() == [application]
    end

    test "get_application!/1 returns the application with given id" do
      application = application_fixture()
      assert Applications.get_application!(application.id) == application
    end

    test "create_application/1 with valid data creates a application" do
      valid_attrs = %{_11grade: 42, _12grade: 42, candidature_grade: 42, course_order_num: 42, exams_grades: 42, phase: 42, placed: true, student_option_number: 42, year: 42}

      assert {:ok, %Application{} = application} = Applications.create_application(valid_attrs)
      assert application._11grade == 42
      assert application._12grade == 42
      assert application.candidature_grade == 42
      assert application.course_order_num == 42
      assert application.exams_grades == 42
      assert application.phase == 42
      assert application.placed == true
      assert application.student_option_number == 42
      assert application.year == 42
    end

    test "create_application/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Applications.create_application(@invalid_attrs)
    end

    test "update_application/2 with valid data updates the application" do
      application = application_fixture()
      update_attrs = %{_11grade: 43, _12grade: 43, candidature_grade: 43, course_order_num: 43, exams_grades: 43, phase: 43, placed: false, student_option_number: 43, year: 43}

      assert {:ok, %Application{} = application} = Applications.update_application(application, update_attrs)
      assert application._11grade == 43
      assert application._12grade == 43
      assert application.candidature_grade == 43
      assert application.course_order_num == 43
      assert application.exams_grades == 43
      assert application.phase == 43
      assert application.placed == false
      assert application.student_option_number == 43
      assert application.year == 43
    end

    test "update_application/2 with invalid data returns error changeset" do
      application = application_fixture()
      assert {:error, %Ecto.Changeset{}} = Applications.update_application(application, @invalid_attrs)
      assert application == Applications.get_application!(application.id)
    end

    test "delete_application/1 deletes the application" do
      application = application_fixture()
      assert {:ok, %Application{}} = Applications.delete_application(application)
      assert_raise Ecto.NoResultsError, fn -> Applications.get_application!(application.id) end
    end

    test "change_application/1 returns a application changeset" do
      application = application_fixture()
      assert %Ecto.Changeset{} = Applications.change_application(application)
    end
  end
end
