defmodule FindYourFriendUniversityWeb.StudentControllerTest do
  use FindYourFriendUniversityWeb.ConnCase

  import FindYourFriendUniversity.StudentsFixtures

  @create_attrs %{civil_id: "civil_id", display_name: "some display_name", id: "_id_", name: "some name"}
  @update_attrs %{civil_id: "civil_id", display_name: "some updated display_name", name: "some updated name"}
  @invalid_attrs %{civil_id: nil, display_name: nil, id: nil, name: nil}

  describe "index" do
    test "lists all students", %{conn: conn} do
      conn = get(conn, ~p"/students")
      assert html_response(conn, 200) =~ "Listing Students"
    end
  end

  describe "new student" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/students/new")
      assert html_response(conn, 200) =~ "New Student"
    end
  end

  describe "create student" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/students", student: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/students/#{id}"

      conn = get(conn, ~p"/students/#{id}")
      assert html_response(conn, 200) =~ "Student #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/students", student: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Student"
    end
  end

  describe "edit student" do
    setup [:create_student]

    test "renders form for editing chosen student", %{conn: conn, student: student} do
      conn = get(conn, ~p"/students/#{student}/edit")
      assert html_response(conn, 200) =~ "Edit Student"
    end
  end

  describe "update student" do
    setup [:create_student]

    test "redirects when data is valid", %{conn: conn, student: student} do
      conn = put(conn, ~p"/students/#{student}", student: @update_attrs)
      assert redirected_to(conn) == ~p"/students/#{student}"

      conn = get(conn, ~p"/students/#{student}")
      assert html_response(conn, 200) =~ student.id
      assert html_response(conn, 200) =~ "civil_id"
      assert html_response(conn, 200) =~ "some updated display_name"
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, student: student} do
      conn = put(conn, ~p"/students/#{student}", student: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Student"
    end
  end

  describe "delete student" do
    setup [:create_student]

    test "deletes chosen student", %{conn: conn, student: student} do
      conn = delete(conn, ~p"/students/#{student}")
      assert redirected_to(conn) == ~p"/students"

      assert_error_sent 404, fn ->
        get(conn, ~p"/students/#{student}")
      end
    end
  end

  defp create_student(_) do
    student = student_fixture()
    %{student: student}
  end
end
