defmodule Syncrojudge.Repo.Migrations.CreateContests do
  use Ecto.Migration
  def change do
    execute(
      "CREATE TYPE contest_status AS ENUM ('draft', 'active', 'frozen', 'finished')",
      "DROP TYPE contest_status"
    )

    create table(:contests) do
      add(:title, :string, null: false)
      add(:description, :text)
      add(:starts_at, :utc_datetime_usec)
      add(:ends_at, :utc_datetime_usec)
      add(:penalty_minutes, :integer, default: 20, null: false)
      add(:freeze_minutes, :integer, default: 60)
      add(:status, :contest_status, default: "draft")
      add(:public_scoreboard, :boolean, default: true)

      timestamps()
    end
  end
end
