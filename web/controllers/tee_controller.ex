defmodule Handiman.TeeController do
  use Handiman.Web, :controller

  alias Handiman.Tee

  plug :scrub_params, "tee" when action in [:create, :update]

  def index(conn, _params) do
    tees = Repo.all(Tee)
    render(conn, "index.html", tees: tees)
  end

  def new(conn, _params) do
    changeset = Tee.changeset(%Tee{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"tee" => tee_params}) do
    changeset = Tee.changeset(%Tee{}, tee_params)

    case Repo.insert(changeset) do
      {:ok, tee} ->
        conn
        |> put_flash(:info, "Tee created successfully.")
        |> redirect(to: course_tee_path(conn, :index, tee.course_id))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
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
        |> redirect(to: course_tee_path(conn, :show, tee.course, tee))
      {:error, changeset} ->
        render(conn, "edit.html", tee: tee, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    tee = Repo.get!(Tee, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(tee)

    conn
    |> put_flash(:info, "Tee deleted successfully.")
    |> redirect(to: course_tee_path(conn, :index, tee.course))
  end
end
