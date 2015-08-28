defmodule Handiman.Repo.Migrations.CreateCourse do
  use Ecto.Migration

  def change do
    create table(:courses) do
      add :name, :string
      add :city, :string
      add :state, :string

      timestamps
    end

  end
end
