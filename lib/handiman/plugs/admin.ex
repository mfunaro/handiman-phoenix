defmodule Handiman.Plugs.Admin do
  use Handiman.Web, :controller
  alias Handiman.Auth

  def init(default), do: default

  def call(conn, _default) do
    if Auth.admin?(conn) do
      conn
    else
      conn |> redirect(to: "/") |> halt
    end
  end
end
