defmodule Syncrojudge.Repo.Migrations.CreateContests do
  use Ecto.Migration

  def change do
    create table(:contests) do
      add :title, :string, null: false
      add :description, :text
      add :starts_at, :utc_datetime_usec
      add :ends_at, :utc_datetime_usec

      timestamps()
    end
  end
end
