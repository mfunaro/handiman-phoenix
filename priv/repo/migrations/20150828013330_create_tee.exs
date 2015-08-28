defmodule Handiman.Repo.Migrations.CreateTee do
  use Ecto.Migration

  def change do
    create table(:tees) do
      add :name, :string
      add :usga_course_rating, :decimal
      add :slope_rating, :integer
      add :front_nine, :string
      add :back_nine, :string
      add :bogey_rating, :decimal
      add :gender, :string
      add :course_id, references(:courses)

      timestamps
    end
    create index(:tees, [:course_id, :gender, :name])
  end
end
