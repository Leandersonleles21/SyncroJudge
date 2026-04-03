defmodule Syncrojudge.Clarification do
  use Ecto.Schema
  import Ecto.Changeset

  schema "clarifications" do
    field(:question, :string)
    field(:answer, :string)
    field(:answered_by, :string)
    field(:broadcast, :boolean, default: false)
    field(:answered_at, :utc_datetime_usec)

    belongs_to(:contest, Syncrojudge.Contest)
    belongs_to(:team, Syncrojudge.Team)
    belongs_to(:problem, Syncrojudge.Problem)

    timestamps()
  end

  @doc "Changeset para time criando uma dúvida"
  def question_changeset(clarification, params \\ %{}) do
    clarification
    |> cast(params, [:question, :contest_id, :team_id, :problem_id])
    |> validate_required([:question, :contest_id, :team_id])
    |> validate_length(:question, min: 1, max: 5000)
    |> assoc_constraint(:contest)
    |> assoc_constraint(:team)
  end

  @doc "Changeset para juiz respondendo uma dúvida"
  def answer_changeset(clarification, params \\ %{}) do
    clarification
    |> cast(params, [:answer, :answered_by, :broadcast, :answered_at])
    |> validate_required([:answer, :answered_by])
    |> validate_length(:answer, min: 1, max: 5000)
    |> put_answered_at()
  end

  defp put_answered_at(changeset) do
    if get_change(changeset, :answer) && !get_field(changeset, :answered_at) do
      put_change(changeset, :answered_at, DateTime.utc_now())
    else
      changeset
    end
  end
end
