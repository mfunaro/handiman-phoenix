defmodule Handiman.Repo.Migrations.AddTeeReferenceToRound do
  use Ecto.Migration

  def change do
    alter table(:rounds) do
      add :tee_id, references(:tees)
      add :differential, :float
    end
  end
end
