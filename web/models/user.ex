defmodule Handiman.User do
  use Handiman.Web, :model

  alias Handiman.Repo

  @differentials %{
    5 => 1,
    6 => 1,
    7 => 2,
    8 =>2,
    9 => 3,
    10 => 3,
    11 => 4,
    12 => 4,
    13 => 5,
    14 => 5,
    15 => 6,
    16 => 6,
    17 => 7,
    18 => 8,
    19 => 9,
    20 => 10
  }

  schema "users" do
    field :name, :string
    field :email, :string
    field :handicap, :integer
    field :encrypted_password, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    has_many :rounds, Handiman.Round
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

  @doc """
  Calculate a handicap for the user defined by the user_id. Use the count to determine the number of differentials to
  consider when calculating the handicap.
  """
  def calculate_handicap(count, user_id) do
    if count < 5 do
      {:error, "User needs more rounds before a handicap can be calculated"}
    else
      if count > 20, do: count = 20 # If the number of rounds is greater than 20 just use 20.
      num_differentials = @differentials[count]
      query = from u in Handiman.User,
              join: r in assoc(u, :rounds),
              where: r.user_id == u.id,
              where: u.id == "#{user_id}",
              select: r.differential,
              order_by: [desc: r.inserted_at],
              limit: "#{num_differentials}"
      diffs = Repo.all(query)
      # TODO move sum into query.
      {_, diff_sum} = Enum.map_reduce(diffs, 0, fn(x, acc) -> {x, acc + x} end)
      {:ok, Float.floor((diff_sum/num_differentials) * 0.96, 1)}
    end
  end

  @doc """
  Get the number of rounds a user has.
  """
  def round_count(user_id) do
    query = from u in Handiman.User, join: r in assoc(u, :rounds), where: r.user_id == "#{user_id}", select: count(r.id)
    Repo.one(query)
  end
end
