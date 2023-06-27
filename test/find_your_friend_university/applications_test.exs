defmodule FindYourFriendUniversity.ApplicationsTest do
  use FindYourFriendUniversity.DataCase

  describe "applications" do
    alias FindYourFriendUniversity.Universities
    alias FindYourFriendUniversity.Courses
    alias FindYourFriendUniversity.Students
    alias FindYourFriendUniversity.Applications
    alias FindYourFriendUniversity.Applications.Application

    import FindYourFriendUniversity.UniversitiesFixtures
    import FindYourFriendUniversity.CoursesFixtures
    import FindYourFriendUniversity.StudentsFixtures
    import FindYourFriendUniversity.ApplicationsFixtures

    @valid_attrs %{
      _11grade: 18,
      _12grade: 13,
      candidature_grade: 16,
      course_order_num: 98,
      exams_grades: 15,
      phase: 2,
      placed: true,
      student_option_number: 2,
      year: 2019
    }
    @invalid_attrs %{
      _11grade: nil,
      _12grade: nil,
      candidature_grade: nil,
      course_order_num: nil,
      exams_grades: nil,
      phase: nil,
      placed: nil,
      student_option_number: nil,
      year: nil
    }
    @update_attrs %{
      _11grade: 15,
      _12grade: 13,
      candidature_grade: 17,
      course_order_num: 13,
      exams_grades: 16,
      phase: 3,
      placed: true,
      student_option_number: 6,
      year: 2019
    }

    test "list_applications/0 returns all applications" do
      application = application_fixture()
      assert Applications.list_applications() == [application]
    end

    test "get_application!/1 returns the application with given id" do
      application = application_fixture()
      assert Applications.get_application!(application.id) == application
    end

    test "create_application/1 with valid data creates a application" do
      university = university_fixture()
      course = course_fixture()
      student = student_fixture()

      valid_attrs =
        Map.merge(@valid_attrs, %{
          university_id: university.id,
          course_id: course.id,
          student_id: student.id
        })

      assert {:ok, %Application{} = application} = Applications.create_application(valid_attrs)

      application =
        application
        |> Repo.preload([:university, :course, :student])

      assert application._11grade == valid_attrs._11grade
      assert application._12grade == valid_attrs._12grade
      assert application.candidature_grade == valid_attrs.candidature_grade
      assert application.course_order_num == valid_attrs.course_order_num
      assert application.exams_grades == valid_attrs.exams_grades
      assert application.phase == valid_attrs.phase
      assert application.placed == valid_attrs.placed
      assert application.student_option_number == valid_attrs.student_option_number
      assert application.year == valid_attrs.year

      assert application.university == university
      assert application.course == course
      assert application.student == student
    end

    test "create_application/1 with valid data but non existing associations ids returns error changeset" do
      valid_attrs_with_non_existing_associations =
        Map.merge(@valid_attrs, %{
          university_id: "2",
          course_id: "3",
          student_id: "4"
        })

      assert {:error, %Ecto.Changeset{} = changeset} =
               Applications.create_application(valid_attrs_with_non_existing_associations)

      assert changeset.errors == [
               university_id:
                 {"does not exist",
                  [{:constraint, :foreign}, {:constraint_name, "applications_university_id_fkey"}]}
             ]

      university_id = university_fixture() |> Map.get(:id)

      valid_attrs_with_non_existing_associations =
        valid_attrs_with_non_existing_associations
        |> Map.update!(:university_id, fn _ -> university_id end)

      assert {:error, %Ecto.Changeset{} = changeset} =
               Applications.create_application(valid_attrs_with_non_existing_associations)

      assert changeset.errors == [
               course_id:
                 {"does not exist",
                  [{:constraint, :foreign}, {:constraint_name, "applications_course_id_fkey"}]}
             ]

      course_id = course_fixture() |> Map.get(:id)

      valid_attrs_with_non_existing_associations =
        valid_attrs_with_non_existing_associations
        |> Map.update!(:course_id, fn _ -> course_id end)

      assert {:error, %Ecto.Changeset{} = changeset} =
               Applications.create_application(valid_attrs_with_non_existing_associations)

      assert changeset.errors == [
               student_id:
                 {"does not exist",
                  [{:constraint, :foreign}, {:constraint_name, "applications_student_id_fkey"}]}
             ]
    end

    test "create_application/1 with valid data but wrong associations ids returns error changeset" do
      valid_attrs_with_wrong_associations =
        Map.merge(@valid_attrs, %{
          university_id: nil,
          course_id: nil,
          student_id: nil
        })

      assert {:error, %Ecto.Changeset{} = changeset} =
               Applications.create_application(valid_attrs_with_wrong_associations)

      assert changeset.errors == [
               university_id: {"can't be blank", [validation: :required]},
               course_id: {"can't be blank", [validation: :required]},
               student_id: {"can't be blank", [validation: :required]}
             ]
    end

    test "create_application/1 with invalid data returns error changeset" do
      invalid_attrs =
        Map.merge(@invalid_attrs, %{
          university_id: nil,
          course_id: nil,
          student_id: nil
        })

      assert {:error, %Ecto.Changeset{}} = Applications.create_application(invalid_attrs)
    end

    test "update_application/2 with valid data updates the application" do
      university = university_fixture()
      course = course_fixture()
      student = student_fixture()
      application = application_fixture()

      update_attrs =
        Map.merge(@update_attrs, %{
          university_id: university.id,
          course_id: course.id,
          student_id: student.id
        })

      assert {:ok, %Application{} = application} =
               Applications.update_application(application, update_attrs)

      assert application._11grade == update_attrs._11grade
      assert application._12grade == update_attrs._12grade
      assert application.candidature_grade == update_attrs.candidature_grade
      assert application.course_order_num == update_attrs.course_order_num
      assert application.exams_grades == update_attrs.exams_grades
      assert application.phase == update_attrs.phase
      assert application.placed == update_attrs.placed
      assert application.student_option_number == update_attrs.student_option_number
      assert application.year == update_attrs.year
    end

    test "update_application/1 with valid data but non existing associations ids returns error changeset" do
      application = application_fixture()

      valid_attrs_with_non_existing_associations =
        Map.merge(@valid_attrs, %{
          university_id: "2",
          course_id: "3",
          student_id: "4"
        })

      assert {:error, %Ecto.Changeset{} = changeset} =
               Applications.update_application(
                 application,
                 valid_attrs_with_non_existing_associations
               )

      assert changeset.errors == [
               university_id:
                 {"does not exist",
                  [{:constraint, :foreign}, {:constraint_name, "applications_university_id_fkey"}]}
             ]

      university_id = university_fixture() |> Map.get(:id)

      valid_attrs_with_non_existing_associations =
        valid_attrs_with_non_existing_associations
        |> Map.update!(:university_id, fn _ -> university_id end)

      assert {:error, %Ecto.Changeset{} = changeset} =
               Applications.update_application(
                 application,
                 valid_attrs_with_non_existing_associations
               )

      assert changeset.errors == [
               course_id:
                 {"does not exist",
                  [{:constraint, :foreign}, {:constraint_name, "applications_course_id_fkey"}]}
             ]

      course_id = course_fixture() |> Map.get(:id)

      valid_attrs_with_non_existing_associations =
        valid_attrs_with_non_existing_associations
        |> Map.update!(:course_id, fn _ -> course_id end)

      assert {:error, %Ecto.Changeset{} = changeset} =
               Applications.update_application(
                 application,
                 valid_attrs_with_non_existing_associations
               )

      assert changeset.errors == [
               student_id:
                 {"does not exist",
                  [{:constraint, :foreign}, {:constraint_name, "applications_student_id_fkey"}]}
             ]
    end

    test "update_application/1 with valid data but wrong associations ids returns error changeset" do
      application = application_fixture()

      valid_attrs_with_wrong_associations =
        Map.merge(@valid_attrs, %{
          university_id: nil,
          course_id: nil,
          student_id: nil
        })

      assert {:error, %Ecto.Changeset{} = changeset} =
               Applications.update_application(application, valid_attrs_with_wrong_associations)

      assert changeset.errors == [
               university_id: {"can't be blank", [validation: :required]},
               course_id: {"can't be blank", [validation: :required]},
               student_id: {"can't be blank", [validation: :required]}
             ]
    end

    test "update_application/2 with invalid data returns error changeset" do
      application = application_fixture()

      invalid_attrs =
        Map.merge(@invalid_attrs, %{
          university_id: nil,
          course_id: nil,
          student_id: nil
        })

      assert {:error, %Ecto.Changeset{}} =
               Applications.update_application(application, invalid_attrs)

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

    test "associations update when university/course/student is updated" do
      application =
        application_fixture()
        |> Repo.preload([:university, :course, :student])

      Universities.update_university(application.university, %{name: "new_university_name"})
      Courses.update_course(application.course, %{name: "new_course_name"})
      Students.update_student(application.student, %{name: "new_student_name"})

      application =
        Applications.get_application!(application.id)
        |> Repo.preload([:university, :course, :student])

      assert application.university.name == "new_university_name"
      assert application.course.name == "new_course_name"
      assert application.student.name == "new_student_name"
    end

    test "deleted when university, course or student is deleted" do
      application =
        application_fixture()
        |> Repo.preload(:university)

      Universities.delete_university(application.university)

      assert_raise Ecto.NoResultsError, fn -> Applications.get_application!(application.id) end

      application =
        application_fixture()
        |> Repo.preload(:course)

      Courses.delete_course(application.course)

      assert_raise Ecto.NoResultsError, fn -> Applications.get_application!(application.id) end

      application =
        application_fixture()
        |> Repo.preload(:student)

      Students.delete_student(application.student)

      assert_raise Ecto.NoResultsError, fn -> Applications.get_application!(application.id) end
    end
  end
end
