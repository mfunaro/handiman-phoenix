defmodule Handiman.RegistrationController do
  use Handiman.Web, :controller
  alias Handiman.User

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, changeset: changeset
  end
end
