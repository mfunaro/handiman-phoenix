defmodule Handiman.SessionControllerTest do
  use Handiman.ConnCase
  alias Handiman.User
  import Ecto.Changeset, only: [put_change: 3]

  @valid_attrs %{email: "test@test.com", password: "password"}
  @invalid_attrs %{email: "wrong@test.com"}
  @user_attrs %{email: "test@test.com", handicap: 42, name: "some content"}

  setup do
    changeset = put_change(User.changeset(%User{}, @user_attrs), :encrypted_password, Comeonin.Bcrypt.hashpwsalt("password"))
    user = Repo.insert!(changeset)
    conn = conn()
    {:ok, conn: conn, user: user}
  end

  test "renders form for login", %{conn: conn} do
    conn = get conn, session_path(conn, :new)
    assert html_response(conn, 200) =~ "Login"
  end

  test "puts resource in session and redirects when data is valid", %{conn: conn, user: user} do
    conn = post conn, session_path(conn, :create), session: @valid_attrs
    assert redirected_to(conn) == page_path(conn, :index)
    assert Plug.Conn.get_session(conn, :current_user) == user.id
  end

  test "renders form for login on error and does not set current_user", %{conn: conn, user: user} do
    conn = post conn, session_path(conn, :create), session: @invalid_attrs
    assert html_response(conn, 200) =~ "Wrong email or password"
    assert Plug.Conn.get_session(conn, :current_user) == nil
  end

  test "removes current_user from session and redirects /", %{conn: conn} do
    conn = delete conn, session_path(conn, :delete)
    assert redirected_to(conn) == page_path(conn, :index)
    assert Plug.Conn.get_session(conn, :current_user) == nil
  end
end
