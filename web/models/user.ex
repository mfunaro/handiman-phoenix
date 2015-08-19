defmodule Handiman.User do
  use Handiman.Web, :model

  schema "users" do
    field :name, :string
    field :email, :string
    field :handicap, :integer
    field :encrypted_password, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps
  end

  @required_fields ~w(name email)
  @optional_fields ~w(handicap password password_confirmation)

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
      |> validate_confirmation(:password)
  end

  @doc """
  Creates a changeset based on the `model` and `params`. But goes further than changeset as it check if there is a password
  supplied. If so, delegate to changeset to run full validations, otherwise run subset of validations.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def update_changeset(model, params \\ :empty) do
    if params[:password] != "" do
      model
      |> changeset(params)
    else
      model
      |> cast(params, @required_fields, @optional_fields)
      |> validate_unique(:email, on: Handiman.Repo, downcase: true)
      |> validate_format(:email, ~r/@/) # TODO more robust email validation
    end
  end
end
