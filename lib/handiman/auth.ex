defmodule Handiman.Auth do
  alias Handiman.User
  alias Handiman.Repo
  import Ecto.Query

  @doc "Returns true if the logged in user is an admin."
  def admin?(conn) do
    user = current_user(conn)
    IO.inspect user
    case current_user(conn) do
      nil  -> false
      user -> Enum.member?(admin_user_ids, user.id)
    end
  end

  @doc "Returns true if the given +object+ belongs to the logged in user."
  def belongs_to_current_user?(conn, object) do
    case current_user(conn) do
      nil  -> false
      user -> object.user_id == user.id
    end
  end

  @doc "Returns the current user."
  def current_user(conn), do: conn.assigns[:current_user]

  @doc "Returns true if a user is logged in."
  def logged_in?(conn), do: !is_nil current_user(conn)

  defp admin_user_ids do
    query = from u in User, where: u.admin == true
    admin_user_ids = Repo.all(query)

    case admin_user_ids do
      nil -> []
      ids -> ids
    end
  end
end
