defmodule Handiman.RegistrationController do
  use Handiman.Web, :controller
  alias Handiman.User

  plug :check_access_allowed

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    if changeset.valid? do
      {_, user} = Handiman.Registration.create(changeset, Handiman.Repo)
      conn
      |> put_session(:current_user, user.id)
      |> put_flash(:info, "Your account wa`s created")
      |> redirect(to: "/")
    else
      conn
      |> render("new.html", changeset: changeset)
    end
  end

  defp check_access_allowed(conn, _) do
    check_access = fn
      _ -> !logged_in?(conn)
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
