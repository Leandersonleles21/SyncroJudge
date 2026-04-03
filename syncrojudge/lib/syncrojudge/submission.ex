defmodule Syncrojudge.Submission do
  use Ecto.Schema
  import Ecto.Changeset

  schema "submissions" do
    belongs_to(:team, Syncrojudge.Teams)
    belongs_to(:problem, Syncrojudge.Problems)
    belongs_to(:contest, Syncrojudge.Contests)

    field(:language, :string)
    field(:source_code, :string)

    field(:status, :string, default: "pending")
    field(:result, :string)

    field(:time_used, :float)
    field(:memory_used, :float)

    field(:completed_at, :utc_datetime_usec)

    timestamps()
  end

  def changeset(submission, params) do
    submission
    |> cast(params, [
      :team_id,
      :problem_id,
      :language,
      :source_code,
      :status,
      :result,
      :time_used,
      :memory_used,
      :completed_at
    ])
    |> validate_required([:team_id, :problem_id, :language, :source_code])
    |> validate_length(:source_code, min: 1, max: 100_000, message: "código muito grande")
    |> validate_inclusion(:language, ["cpp", "python"])
    |> validate_number(:time_used, greater_than_or_equal_to: 0.0)
    |> validate_number(:memory_used, greater_than_or_equal_to: 0.0)
  end
end
