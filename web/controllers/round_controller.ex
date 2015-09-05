defmodule Handiman.RoundController do
  use Handiman.Web, :controller
  import Ecto.Query, only: [where: 3, from: 2]
  import Ecto.Changeset, only: [put_change: 3]
  require Logger
  alias Handiman.Round
  alias Handiman.Tee
  alias Handiman.Course

  plug :scrub_params, "round" when action in [:create, :update]

  def index(conn,  %{"user_id" => user_id}) do
    # Query for only the current_user's rounds.
    query = from r in Round, where: r.user_id == "#{user_id}"
    rounds = Repo.all(query)
    render(conn, "index.html", rounds: rounds)
  end

  def new(conn, %{"user_id" => user_id}) do
    changeset = Round.changeset(%Round{})
    {courses, tees} = retrieve_courses_and_tees
    render(conn, "new.html", changeset: changeset, tees: tees, courses: courses)
  end

  def create(conn, %{"round" => round_params, "user_id" => user_id}) do
    {courses, tees} = retrieve_courses_and_tees
    if round_params["tee_id"] == nil do
      conn
        |> put_flash(:error, "You must select which tee you played from")
        |> render("new.html", changeset: Round.changeset(%Round{}, round_params), tees: tees, courses: courses)
    end
    tee = Repo.get!(Tee, round_params["tee_id"])
    diff = Round.calc_differential(round_params["score"], tee.usga_course_rating, tee.slope_rating)
      |> Float.round(2)
    changeset = Round.changeset(%Round{}, Map.merge(round_params, %{"user_id"=> user_id, "differential"=> diff}))

    case Repo.insert(changeset) do
      {:ok, round} ->
        conn
        |> put_flash(:info, "Round created successfully.")
        |> redirect(to: user_round_path(conn, :index, round.user_id))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, tees: tees, courses: courses)
    end
  end

  def show(conn, %{"id" => id}) do
    round = Repo.get!(Round, id)
    render(conn, "show.html", round: round)
  end

  def edit(conn, %{"id" => id}) do
    round = Repo.get!(Round, id)
    changeset = Round.changeset(round)
    render(conn, "edit.html", round: round, changeset: changeset)
  end

  def update(conn, %{"id" => id, "round" => round_params}) do
    round = Repo.get!(Round, id)
    changeset = Round.changeset(round, round_params)

    case Repo.update(changeset) do
      {:ok, round} ->
        round = Repo.preload(round, :user)
        conn
        |> put_flash(:info, "Round updated successfully.")
        |> redirect(to: user_round_path(conn, :show, round.user, round))
      {:error, changeset} ->
        render(conn, "edit.html", round: round, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    round = Repo.get!(Round, id)
    round = Repo.preload(round, :user)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(round)

    conn
    |> put_flash(:info, "Round deleted successfully.")
    |> redirect(to: user_round_path(conn, :index, round.user))
  end

  defp retrieve_courses_and_tees() do
    course_query = from c in Course, select: %{"course_id"=>c.id, "course_name"=>c.name}
    tee_query = from t in Tee, select: %{"tee_id"=>t.id, "course_id"=>t.course_id}
    tees = Repo.all(tee_query)
    courses = Repo.all(course_query)
    {courses, tees}
  end
end
