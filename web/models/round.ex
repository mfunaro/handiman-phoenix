defmodule Handiman.Round do
  use Handiman.Web, :model

  schema "rounds" do
    field :score, :integer
    field :holes, :integer
    belongs_to :user, Handiman.User
    belongs_to :tee, Handiman.Tee

    timestamps
  end

  @required_fields ~w(score holes)
  @optional_fields ~w(user_id)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
  
  def with_course(query) do
    from q in query, preload: [tee: :course]
  end
end
