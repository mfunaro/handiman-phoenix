defmodule Handiman.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :handicap, :integer

      timestamps
    end

  end
end
