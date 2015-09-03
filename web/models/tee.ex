defmodule Handiman.Tee do
  use Handiman.Web, :model

  schema "tees" do
    field :name, :string
    field :usga_course_rating, :float
    field :slope_rating, :integer
    field :front_nine, :string
    field :back_nine, :string
    field :bogey_rating, :float
    field :gender, :string

    belongs_to :course, Handiman.Course
    has_many :round, Hamdiman.Round
    timestamps
  end

  @required_fields ~w(name usga_course_rating slope_rating front_nine back_nine bogey_rating gender course_id)
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
