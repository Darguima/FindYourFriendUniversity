defmodule FindYourFriendUniversityWeb.UniversityControllerTest do
  use FindYourFriendUniversityWeb.ConnCase

  import FindYourFriendUniversity.UniversitiesFixtures

  @create_attrs %{name: "some name", code_id: 42, is_polytechnic: true}
  @update_attrs %{name: "some updated name", code_id: 43, is_polytechnic: false}
  @invalid_attrs %{name: nil, code_id: nil, is_polytechnic: nil}

  describe "index" do
    test "lists all universities", %{conn: conn} do
      conn = get(conn, ~p"/universities")
      assert html_response(conn, 200) =~ "Listing Universities"
    end
  end

  describe "new university" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/universities/new")
      assert html_response(conn, 200) =~ "New University"
    end
  end

  describe "create university" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/universities", university: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/universities/#{id}"

      conn = get(conn, ~p"/universities/#{id}")
      assert html_response(conn, 200) =~ "University #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/universities", university: @invalid_attrs)
      assert html_response(conn, 200) =~ "New University"
    end
  end

  describe "edit university" do
    setup [:create_university]

    test "renders form for editing chosen university", %{conn: conn, university: university} do
      conn = get(conn, ~p"/universities/#{university}/edit")
      assert html_response(conn, 200) =~ "Edit University"
    end
  end

  describe "update university" do
    setup [:create_university]

    test "redirects when data is valid", %{conn: conn, university: university} do
      conn = put(conn, ~p"/universities/#{university}", university: @update_attrs)
      assert redirected_to(conn) == ~p"/universities/#{university}"

      conn = get(conn, ~p"/universities/#{university}")
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, university: university} do
      conn = put(conn, ~p"/universities/#{university}", university: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit University"
    end
  end

  describe "delete university" do
    setup [:create_university]

    test "deletes chosen university", %{conn: conn, university: university} do
      conn = delete(conn, ~p"/universities/#{university}")
      assert redirected_to(conn) == ~p"/universities"

      assert_error_sent 404, fn ->
        get(conn, ~p"/universities/#{university}")
      end
    end
  end

  defp create_university(_) do
    university = university_fixture()
    %{university: university}
  end
end
