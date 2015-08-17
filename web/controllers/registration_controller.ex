defmodule Handiman.RegistrationController do
  use Handiman.Web, :controller
  alias Handiman.User

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
end
