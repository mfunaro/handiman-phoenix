defmodule Handiman.TeeControllerTest do
  use Handiman.ConnCase

  alias Handiman.Tee
  @valid_attrs %{back_nine: "some content", bogey_rating: "120.5", front_nine: "some content", gender: "some content", name: "some content", slope_rating: 42, usga_course_rating: "120.5"}
  @invalid_attrs %{}

  setup do
    conn = conn()
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, tee_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing tees"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, tee_path(conn, :new)
    assert html_response(conn, 200) =~ "New tee"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, tee_path(conn, :create), tee: @valid_attrs
    assert redirected_to(conn) == tee_path(conn, :index)
    assert Repo.get_by(Tee, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, tee_path(conn, :create), tee: @invalid_attrs
    assert html_response(conn, 200) =~ "New tee"
  end

  test "shows chosen resource", %{conn: conn} do
    tee = Repo.insert! %Tee{}
    conn = get conn, tee_path(conn, :show, tee)
    assert html_response(conn, 200) =~ "Show tee"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, tee_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    tee = Repo.insert! %Tee{}
    conn = get conn, tee_path(conn, :edit, tee)
    assert html_response(conn, 200) =~ "Edit tee"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    tee = Repo.insert! %Tee{}
    conn = put conn, tee_path(conn, :update, tee), tee: @valid_attrs
    assert redirected_to(conn) == tee_path(conn, :show, tee)
    assert Repo.get_by(Tee, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    tee = Repo.insert! %Tee{}
    conn = put conn, tee_path(conn, :update, tee), tee: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit tee"
  end

  test "deletes chosen resource", %{conn: conn} do
    tee = Repo.insert! %Tee{}
    conn = delete conn, tee_path(conn, :delete, tee)
    assert redirected_to(conn) == tee_path(conn, :index)
    refute Repo.get(Tee, tee.id)
  end
end
