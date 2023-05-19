defmodule FindYourFriendUniversityWeb.CourseControllerTest do
  use FindYourFriendUniversityWeb.ConnCase

  import FindYourFriendUniversity.CoursesFixtures

  @create_attrs %{name: "some name", code_id: 42}
  @update_attrs %{name: "some updated name", code_id: 43}
  @invalid_attrs %{name: nil, code_id: nil}

  describe "index" do
    test "lists all courses", %{conn: conn} do
      conn = get(conn, ~p"/courses")
      assert html_response(conn, 200) =~ "Listing Courses"
    end
  end

  describe "new course" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/courses/new")
      assert html_response(conn, 200) =~ "New Course"
    end
  end

  describe "create course" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/courses", course: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/courses/#{id}"

      conn = get(conn, ~p"/courses/#{id}")
      assert html_response(conn, 200) =~ "Course #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/courses", course: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Course"
    end
  end

  describe "edit course" do
    setup [:create_course]

    test "renders form for editing chosen course", %{conn: conn, course: course} do
      conn = get(conn, ~p"/courses/#{course}/edit")
      assert html_response(conn, 200) =~ "Edit Course"
    end
  end

  describe "update course" do
    setup [:create_course]

    test "redirects when data is valid", %{conn: conn, course: course} do
      conn = put(conn, ~p"/courses/#{course}", course: @update_attrs)
      assert redirected_to(conn) == ~p"/courses/#{course}"

      conn = get(conn, ~p"/courses/#{course}")
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, course: course} do
      conn = put(conn, ~p"/courses/#{course}", course: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Course"
    end
  end

  describe "delete course" do
    setup [:create_course]

    test "deletes chosen course", %{conn: conn, course: course} do
      conn = delete(conn, ~p"/courses/#{course}")
      assert redirected_to(conn) == ~p"/courses"

      assert_error_sent 404, fn ->
        get(conn, ~p"/courses/#{course}")
      end
    end
  end

  defp create_course(_) do
    course = course_fixture()
    %{course: course}
  end
end
