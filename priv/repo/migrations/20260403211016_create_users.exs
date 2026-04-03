defmodule Syncrojudge.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    execute(
      "CREATE TYPE user_role AS ENUM ('admin', 'judge')",
      "DROP TYPE user_role"
    )

    create table(:users) do
      add(:name, :string, null: false)
      add(:email, :string, null: false)
      add(:password_hash, :string, null: false)
      add(:role, :user_role, default: "judge", null: false)
      add(:active, :boolean, default: true, null: false)

      timestamps()
    end

    create(unique_index(:users, [:email]))
  end
end
