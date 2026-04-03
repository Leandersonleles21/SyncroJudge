defmodule Syncrojudge.Contest do
  use Ecto.Schema
  import Ecto.Changeset

  @statuses ~w(draft active frozen finished)

  schema "contests" do
    field(:title, :string)
    field(:description, :string)
    field(:starts_at, :utc_datetime_usec)
    field(:ends_at, :utc_datetime_usec)
    field(:penalty_minutes, :integer, default: 20)
    field(:freeze_minutes, :integer, default: 60)
    field(:status, :string, default: "draft")
    field(:public_scoreboard, :boolean, default: true)

    has_many(:teams, Syncrojudge.Team)
    has_many(:problems, Syncrojudge.Problem)
    has_many(:submissions, Syncrojudge.Submission)
    has_many(:clarifications, Syncrojudge.Clarification)

    timestamps()
  end

  @required_fields ~w(title)a
  @optional_fields ~w(description starts_at ends_at penalty_minutes freeze_minutes status public_scoreboard)a

  def changeset(contest, params \\ %{}) do
    contest
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_length(:title, min: 1, max: 255)
    |> validate_inclusion(:status, @statuses, message: "deve ser: #{Enum.join(@statuses, ", ")}")
    |> validate_number(:penalty_minutes, greater_than_or_equal_to: 0)
    |> validate_number(:freeze_minutes, greater_than_or_equal_to: 0)
    |> validate_dates()
  end

  defp validate_dates(changeset) do
    starts = get_field(changeset, :starts_at)
    ends = get_field(changeset, :ends_at)

    if starts && ends && DateTime.compare(ends, starts) != :gt do
      add_error(changeset, :ends_at, "deve ser depois de starts_at")
    else
      changeset
    end
  end
end
