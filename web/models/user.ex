defmodule Handiman.User do
  use Handiman.Web, :model

  schema "users" do
    field :name, :string
    field :email, :string
    field :handicap, :integer
    field :encrypted_password, :string
    field :password, :string, virtual: true

    timestamps
  end

  @required_fields ~w(email password)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_unique(:email, on: Handiman.Repo, downcase: true)
    |> validate_format(:email, ~r/@/) # TODO more robust email validation
    |> validate_length(:password, min: 5)
  end
end
