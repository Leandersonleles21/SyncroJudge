defmodule Syncrojudge.Submission do
  use Ecto.Schema
  import Ecto.Changeset

  @languages ~w(c cpp java python kotlin)
  @statuses ~w(pending queued judging accepted wrong_answer time_limit memory_limit runtime_error compilation_error)
  @results ~w(accepted wrong_answer time_limit memory_limit runtime_error compilation_error)

  schema "submissions" do
    field(:language, :string)
    field(:source_code_path, :string)
    field(:source_code, :string)

    field(:status, :string, default: "pending")
    field(:result, :string)

    field(:time_used_ms, :integer)
    field(:memory_used_mb, :integer)

    field(:submitted_at, :utc_datetime_usec)
    field(:completed_at, :utc_datetime_usec)

    field(:judge_message, :string)
    field(:test_case_failed, :integer)
    field(:attempt_number, :integer)

    belongs_to(:team, Syncrojudge.Team)
    belongs_to(:problem, Syncrojudge.Problem)
    belongs_to(:contest, Syncrojudge.Contest)

    timestamps()
  end

  @doc "Changeset para time submetendo uma solução"
  def submit_changeset(submission, params) do
    submission
    |> cast(params, [
      :team_id,
      :problem_id,
      :contest_id,
      :language,
      :source_code,
      :source_code_path,
      :submitted_at,
      :attempt_number
    ])
    |> validate_required([:team_id, :problem_id, :contest_id, :language, :submitted_at])
    |> validate_at_least_one_source()
    |> validate_inclusion(:language, @languages, message: "linguagem deve ser: #{Enum.join(@languages, ", ")}")
    |> validate_length(:source_code, max: 100_000, message: "código muito grande (max 100KB)")
    |> validate_number(:attempt_number, greater_than: 0)
    |> assoc_constraint(:team)
    |> assoc_constraint(:problem)
    |> assoc_constraint(:contest)
  end

  @doc "Changeset para o juiz atualizando resultado"
  def judge_changeset(submission, params) do
    submission
    |> cast(params, [
      :status,
      :result,
      :time_used_ms,
      :memory_used_mb,
      :completed_at,
      :judge_message,
      :test_case_failed
    ])
    |> validate_inclusion(:status, @statuses)
    |> validate_inclusion(:result, @results)
    |> validate_number(:time_used_ms, greater_than_or_equal_to: 0)
    |> validate_number(:memory_used_mb, greater_than_or_equal_to: 0)
    |> validate_number(:test_case_failed, greater_than_or_equal_to: 1)
  end

  defp validate_at_least_one_source(changeset) do
    code = get_field(changeset, :source_code)
    path = get_field(changeset, :source_code_path)

    if is_nil(code) and is_nil(path) do
      add_error(changeset, :source_code, "source_code ou source_code_path é obrigatório")
    else
      changeset
    end
  end
end
