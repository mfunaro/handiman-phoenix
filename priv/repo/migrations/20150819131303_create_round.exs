defmodule Handiman.Repo.Migrations.CreateRound do
  use Ecto.Migration

  def change do
    create table(:rounds) do
      add :score, :integer
      add :holes, :integer
      add :user_id, references(:users)

      timestamps
    end
    create index(:rounds, [:user_id])
  end
end
