defmodule Handiman.TeeController do
  use Handiman.Web, :controller
  import Ecto.Query, only: [where: 3, from: 2]

  alias Handiman.Course
  alias Handiman.Tee
  plug :scrub_params, "tee" when action in [:create, :update]

  def index(conn, %{"course_id" => course_id}) do
    course = Repo.get!(Course, course_id)
    query = from r in Tee, where: r.course_id == "#{course_id}"
    tees = Repo.all(query)
    render(conn, "index.html", tees: tees, course: course)
  end

  def new(conn, %{"course_id" => course_id}) do
    course = Repo.get!(Course, course_id)
    changeset = Tee.changeset(%Tee{})
    render(conn, "new.html", changeset: changeset, course: course)
  end

  def create(conn, %{"tee" => tee_params, "course_id" => course_id}) do
    course = Repo.get!(Course, course_id)
    changeset = Tee.changeset(%Tee{}, Map.merge(tee_params, %{"course_id"=> course_id}))

    case Repo.insert(changeset) do
      {:ok, tee} ->
        conn
        |> put_flash(:info, "Tee created successfully.")
        |> redirect(to: course_tee_path(conn, :index, tee.course_id))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, course: course)
    end
  end

  def show(conn, %{"id" => id}) do
    tee = Repo.get!(Tee, id)
    render(conn, "show.html", tee: tee)
  end

  def edit(conn, %{"id" => id}) do
    tee = Repo.get!(Tee, id)
    changeset = Tee.changeset(tee)
    render(conn, "edit.html", tee: tee, changeset: changeset)
  end

  def update(conn, %{"id" => id, "tee" => tee_params}) do
    tee = Repo.get!(Tee, id)
    changeset = Tee.changeset(tee, tee_params)

    case Repo.update(changeset) do
      {:ok, tee} ->
        conn
        |> put_flash(:info, "Tee updated successfully.")
        |> redirect(to: course_tee_path(conn, :show, tee.course_id, tee))
      {:error, changeset} ->
        render(conn, "edit.html", tee: tee, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    tee = Repo.get!(Tee, id)
    tee = Repo.preload(tee, :course)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(tee)

    conn
    |> put_flash(:info, "Tee deleted successfully.")
    |> redirect(to: course_tee_path(conn, :index, tee.course))
  end
end
