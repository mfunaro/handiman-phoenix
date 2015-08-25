defmodule Handiman.RoundControllerTest do
  use Handiman.ConnCase
  import Ecto.Changeset, only: [put_change: 3]
  alias Handiman.Round
  alias Handiman.User

  @valid_attrs %{holes: 42, score: 42}
  @user_attrs %{email: "test@test.com", handicap: 42, name: "some content"}
  @invalid_attrs %{}

  setup do
    changeset = put_change(User.changeset(%User{}, @user_attrs), :encrypted_password, Comeonin.Bcrypt.hashpwsalt("password"))
    user = Repo.insert!(changeset)
    round = Repo.insert!(Round.changeset(%Round{}, %{holes: 18, score: 7, user_id: user.id}))
    conn = conn()
      |> post("/login", %{session: %{email: "test@test.com", password: "password"}})
    {:ok, conn: conn, user: user, round: round}
  end

  test "lists all entries on index", %{conn: conn, user: user} do
    conn = get conn, user_round_path(conn, :index, user)
    assert html_response(conn, 200) =~ "Listing rounds"
  end

  test "renders form for new resources", %{conn: conn, user: user} do
    conn = get conn, user_round_path(conn, :new, user)
    assert html_response(conn, 200) =~ "New round"
  end

  test "creates resource and redirects when data is valid", %{conn: conn, user: user} do
    conn = post conn, user_round_path(conn, :create, user), round: @valid_attrs
    assert redirected_to(conn) == user_round_path(conn, :index, user)
    assert Repo.get_by(Round, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, user: user} do
    conn = post conn, user_round_path(conn, :create, user), round: @invalid_attrs
    assert html_response(conn, 200) =~ "New round"
  end

  test "shows chosen resource", %{conn: conn, user: user} do
    round = Repo.insert! %Round{}
    conn = get conn, user_round_path(conn, :show, user, round)
    assert html_response(conn, 200) =~ "Show round"
  end

  test "renders page not found when id is nonexistent", %{conn: conn, user: user} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, user_round_path(conn, :show, user, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn, user: user} do
    round = Repo.insert! %Round{}
    conn = get conn, user_round_path(conn, :edit, user, round)
    assert html_response(conn, 200) =~ "Edit round"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn, user: user} do
    round = Repo.insert! Round.changeset(%Round{}, %{user_id: user.id, score: 1, holes: 1})
    conn = put conn, user_round_path(conn, :update, user, round), round: @valid_attrs
    assert redirected_to(conn) == user_round_path(conn, :show, user, round)
    assert Repo.get_by(Round, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, user: user} do
    round = Repo.insert! %Round{}
    conn = put conn, user_round_path(conn, :update, user, round), round: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit round"
  end

  test "deletes chosen resource", %{conn: conn, user: user} do
    round = Repo.insert! Round.changeset(%Round{}, %{user_id: user.id, score: 1, holes: 1})
    conn = delete conn, user_round_path(conn, :delete, user, round)
    assert redirected_to(conn) == user_round_path(conn, :index, user)
    refute Repo.get(Round, round.id)
  end
end
