defmodule FindYourFriendUniversityWeb.ApplicationControllerTest do
  use FindYourFriendUniversityWeb.ConnCase

  import FindYourFriendUniversity.UniversitiesFixtures
  import FindYourFriendUniversity.CoursesFixtures
  import FindYourFriendUniversity.StudentsFixtures
  import FindYourFriendUniversity.ApplicationsFixtures

  @create_attrs %{
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

  describe "index" do
    test "lists all applications", %{conn: conn} do
      conn = get(conn, ~p"/applications")
      assert html_response(conn, 200) =~ "Listing Applications"
    end
  end

  describe "new application" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/applications/new")
      assert html_response(conn, 200) =~ "New Application"
    end
  end

  describe "create application" do
    test "redirects to show when data is valid", %{conn: conn} do
      university = university_fixture()
      course = course_fixture()
      student = student_fixture()

      create_attrs =
        Map.merge(@create_attrs, %{
          university_id: university.id,
          course_id: course.id,
          student_id: student.id
        })

      conn = post(conn, ~p"/applications", application: create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/applications/#{id}"

      conn = get(conn, ~p"/applications/#{id}")
      assert html_response(conn, 200) =~ "Application #{id}"
    end

    test "renders errors when data is valid but with wrong associations ids", %{conn: conn} do
      valid_attrs_with_wrong_associations =
        Map.merge(@create_attrs, %{
          university_id: nil,
          course_id: nil,
          student_id: nil
        })

      conn = post(conn, ~p"/applications", application: valid_attrs_with_wrong_associations)
      assert html_response(conn, 200) =~ "New Application"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/applications", application: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Application"
    end
  end

  describe "edit application" do
    setup [:create_application]

    test "renders form for editing chosen application", %{conn: conn, application: application} do
      conn = get(conn, ~p"/applications/#{application}/edit")
      assert html_response(conn, 200) =~ "Edit Application"
    end
  end

  describe "update application" do
    setup [:create_application]

    test "redirects when data is valid", %{conn: conn, application: application} do
      conn = put(conn, ~p"/applications/#{application}", application: @update_attrs)
      assert redirected_to(conn) == ~p"/applications/#{application}"

      conn = get(conn, ~p"/applications/#{application}")
      assert html_response(conn, 200)
    end

    test "renders errors when data is valid but with wrong associations ids", %{
      conn: conn,
      application: application
    } do
      valid_attrs_with_wrong_associations =
        Map.merge(@update_attrs, %{
          university_id: nil,
          course_id: nil,
          student_id: nil
        })

      conn =
        put(conn, ~p"/applications/#{application}",
          application: valid_attrs_with_wrong_associations
        )

      assert html_response(conn, 200) =~ "Edit Application"
    end

    test "renders errors when data is invalid", %{conn: conn, application: application} do
      conn = put(conn, ~p"/applications/#{application}", application: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Application"
    end
  end

  describe "delete application" do
    setup [:create_application]

    test "deletes chosen application", %{conn: conn, application: application} do
      conn = delete(conn, ~p"/applications/#{application}")
      assert redirected_to(conn) == ~p"/applications"

      assert_error_sent(404, fn ->
        get(conn, ~p"/applications/#{application}")
      end)
    end
  end

  defp create_application(_) do
    application = application_fixture()
    %{application: application}
  end
end
