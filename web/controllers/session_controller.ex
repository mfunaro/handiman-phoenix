defmodule Handiman.SessionController do
  use Handiman.Web, :controller

  plug :check_access_allowed

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => session_params}) do
    case Handiman.Session.login(session_params, Handiman.Repo) do
      {:ok, user} ->
        conn
        |> put_session(:current_user, user.id)
        |> put_flash(:info, "Logged in")
        |> redirect(to: user_path(conn, :show, user.id))
      :error ->
        conn
        |> put_flash(:info, "Wrong email or password")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> delete_session(:current_user)
    |> put_flash(:info, "Logged out")
    |> redirect(to: "/")
  end

  defp check_access_allowed(conn, _) do
    check_access = fn
      :delete -> logged_in?(conn)
      :create -> !logged_in?(conn)
      :new -> !logged_in?(conn)
    end

    if check_access.(action_name(conn)) do
      conn
    else
      conn
      |> halt
      |> redirect(to: "/")
    end
  end
end
