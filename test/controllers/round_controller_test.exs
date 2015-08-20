defmodule Handiman.RoundControllerTest do
  use Handiman.ConnCase
  require Logger
  require IEx
  alias Handiman.Round
  alias Handiman.User

  @valid_attrs %{holes: 42, score: 42}
  @invalid_attrs %{}

  setup do
    conn = conn()
    user = Repo.insert! %User{email: "test@test.com", handicap: 42, name: "some content"}
    round = Repo.insert! %Round{holes: 18, score: 7}
    {:ok, conn: conn, user: user, round: round}
  end

  test "lists all entries on index", %{conn: conn, user: user, round: round} do
    IEx.pry
    conn = get conn, user_round_path(conn, :index, round)
    assert html_response(conn, 200) =~ "Listing rounds"
  end

  test "renders form for new resources", %{conn: conn, user: user} do
    conn = get conn, user_round_path(conn, :new, user, %Round{})
    assert html_response(conn, 200) =~ "New round"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, user_round_path(conn, :create, %User{}), round: @valid_attrs
    assert redirected_to(conn) == user_round_path(conn, :index, %User{})
    assert Repo.get_by(Round, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_round_path(conn, :create, %User{}), round: @invalid_attrs
    assert html_response(conn, 200) =~ "New round"
  end

  test "shows chosen resource", %{conn: conn} do
    round = Repo.insert! %Round{}
    conn = get conn, user_round_path(conn, :show, %User{}, round)
    assert html_response(conn, 200) =~ "Show round"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, user_round_path(conn, :show, %User{}, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    round = Repo.insert! %Round{}
    conn = get conn, user_round_path(conn, :edit, %User{}, round)
    assert html_response(conn, 200) =~ "Edit round"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    round = Repo.insert! %Round{}
    conn = put conn, user_round_path(conn, :update, %User{}, round), round: @valid_attrs
    assert redirected_to(conn) == user_round_path(conn, :show, %User{}, round)
    assert Repo.get_by(Round, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    round = Repo.insert! %Round{}
    conn = put conn, user_round_path(conn, :update, %User{}, round), round: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit round"
  end

  test "deletes chosen resource", %{conn: conn} do
    round = Repo.insert! %Round{}
    conn = delete conn, user_round_path(conn, :delete, %User{}, round)
    assert redirected_to(conn) == user_round_path(conn, :index, %User{})
    refute Repo.get(Round, round.id)
  end
end
