defmodule FindYourFriendUniversityWeb.ApplicationControllerTest do
  use FindYourFriendUniversityWeb.ConnCase

  import FindYourFriendUniversity.ApplicationsFixtures

  @create_attrs %{_11grade: 42, _12grade: 42, candidature_grade: 42, course_order_num: 42, exams_grades: 42, phase: 42, placed: true, student_option_number: 42, year: 42}
  @update_attrs %{_11grade: 43, _12grade: 43, candidature_grade: 43, course_order_num: 43, exams_grades: 43, phase: 43, placed: false, student_option_number: 43, year: 43}
  @invalid_attrs %{_11grade: nil, _12grade: nil, candidature_grade: nil, course_order_num: nil, exams_grades: nil, phase: nil, placed: nil, student_option_number: nil, year: nil}

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
      conn = post(conn, ~p"/applications", application: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/applications/#{id}"

      conn = get(conn, ~p"/applications/#{id}")
      assert html_response(conn, 200) =~ "Application #{id}"
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

      assert_error_sent 404, fn ->
        get(conn, ~p"/applications/#{application}")
      end
    end
  end

  defp create_application(_) do
    application = application_fixture()
    %{application: application}
  end
end
