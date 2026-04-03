defmodule Syncrojudge.ScoreboardEntry do
  @moduledoc """
  Cache materializado do scoreboard — uma linha por time+problema por contest.
  Atualizado toda vez que uma submissão é julgada.

  ## Lógica ICPC
  - `attempts`: submissões erradas antes do accepted
  - `solved_at_minute`: minuto relativo ao início do contest em que acertou
  - `penalty`: solved_at_minute + (attempts × contest.penalty_minutes)
  - `frozen`: true se o accepted aconteceu durante o freeze
  - `pending_count`: submissões ainda não julgadas durante freeze
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "scoreboard_entries" do
    field(:attempts, :integer, default: 0)
    field(:solved, :boolean, default: false)
    field(:solved_at_minute, :integer)
    field(:penalty, :integer, default: 0)
    field(:frozen, :boolean, default: false)
    field(:pending_count, :integer, default: 0)
    field(:first_submission_at, :utc_datetime_usec)

    belongs_to(:contest, Syncrojudge.Contest)
    belongs_to(:team, Syncrojudge.Team)
    belongs_to(:problem, Syncrojudge.Problem)

    timestamps()
  end

  @required_fields ~w(contest_id team_id problem_id)a
  @optional_fields ~w(attempts solved solved_at_minute penalty frozen pending_count first_submission_at)a

  @doc "Changeset para criar uma entrada vazia (primeira submissão do time neste problema)"
  def changeset(entry, params \\ %{}) do
    entry
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_number(:attempts, greater_than_or_equal_to: 0)
    |> validate_number(:penalty, greater_than_or_equal_to: 0)
    |> validate_number(:solved_at_minute, greater_than_or_equal_to: 0)
    |> validate_number(:pending_count, greater_than_or_equal_to: 0)
    |> unique_constraint([:contest_id, :team_id, :problem_id],
      message: "entrada já existe para este time/problema"
    )
    |> assoc_constraint(:contest)
    |> assoc_constraint(:team)
    |> assoc_constraint(:problem)
  end

  @doc "Changeset para registrar uma submissão errada"
  def wrong_answer_changeset(entry, params \\ %{}) do
    entry
    |> cast(params, [:attempts])
    |> validate_number(:attempts, greater_than_or_equal_to: 0)
  end

  @doc "Changeset para registrar accepted"
  def accepted_changeset(entry, params) do
    entry
    |> cast(params, [:solved, :solved_at_minute, :penalty, :frozen])
    |> put_change(:solved, true)
    |> validate_required([:solved_at_minute, :penalty])
    |> validate_number(:solved_at_minute, greater_than_or_equal_to: 0)
    |> validate_number(:penalty, greater_than_or_equal_to: 0)
  end

  @doc "Changeset para atualizar contagem de pendentes durante freeze"
  def freeze_changeset(entry, params) do
    entry
    |> cast(params, [:pending_count, :frozen])
    |> put_change(:frozen, true)
    |> validate_number(:pending_count, greater_than_or_equal_to: 0)
  end
end
