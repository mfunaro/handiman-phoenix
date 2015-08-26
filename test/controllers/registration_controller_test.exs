defmodule Handiman.RegistrationControllerTest do
  use Handiman.ConnCase
  alias Handiman.User
  import Ecto.Changeset, only: [put_change: 3]


  @valid_attrs %{name: "name", email: "email@test.com", password: "password", password_confirmation: "password"}
  @fail_confirmation %{name: "name", email: "email@test.com", password: "password", password_confirmation: "fail"}
  @fail_length %{name: "name", email: "email@test.com", password: "pass", password_confirmation: "pass"}
  @invalid_attrs %{}

  setup do
    conn = conn()
    {:ok, conn: conn}
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, registration_path(conn, :new)
    assert html_response(conn, 200) =~ "Password Confirmation"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, registration_path(conn, :create), user: @valid_attrs
    assert redirected_to(conn) == page_path(conn, :index)
    assert Repo.get_by(User, email: "email@test.com")
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, registration_path(conn, :create), user: @invalid_attrs
    assert html_response(conn, 200) =~ "Oops, something went wrong!"
  end

  test "does not create resource if password confirmation fails", %{conn: conn} do
    conn = post conn, registration_path(conn, :create), user: @fail_confirmation
    assert html_response(conn, 200) =~ "Oops, something went wrong!"
  end

  test "does not create resource if password does not meet length requirements", %{conn: conn} do
    conn = post conn, registration_path(conn, :create), user: @fail_length
    assert html_response(conn, 200) =~ "Oops, something went wrong!"
  end

  test "only allow access to registration when not logged in" do
    changeset = put_change(User.changeset(%User{}, @valid_attrs), :encrypted_password, Comeonin.Bcrypt.hashpwsalt("password"))
    user = Repo.insert!(changeset)
    conn = conn()
      |> post("/login", %{session: %{email: "email@test.com", password: "password"}})
      |> get registration_path(conn, :new)
    assert redirected_to(conn) == page_path(conn, :index)

    get conn, registration_path(conn, :create), user: @valid_attrs
    assert redirected_to(conn) == page_path(conn, :index)
  end
end
