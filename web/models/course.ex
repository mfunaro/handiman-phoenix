defmodule Handiman.Course do
  use Handiman.Web, :model

  schema "courses" do
    field :name, :string
    field :city, :string
    field :state, :string

    has_many :tees, Handiman.Tee
    timestamps
  end

  @required_fields ~w(name city state)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
