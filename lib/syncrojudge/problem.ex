defmodule Syncrojudge.Problem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "problems" do
    field(:title, :string)
    field(:label, :string)
    field(:time_limit_ms, :integer, default: 1000)
    field(:memory_limit_mb, :integer, default: 256)
    field(:pdf_path, :string)
    field(:color, :string)
    field(:position, :integer)

    belongs_to(:contest, Syncrojudge.Contest)
    has_many(:test_cases, Syncrojudge.TestCase)
    has_many(:submissions, Syncrojudge.Submission)
    has_many(:clarifications, Syncrojudge.Clarification)
    has_many(:scoreboard_entries, Syncrojudge.ScoreboardEntry)

    timestamps()
  end

  @required_fields ~w(title label contest_id)a
  @optional_fields ~w(time_limit_ms memory_limit_mb pdf_path color position)a

  def changeset(problem, params \\ %{}) do
    problem
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_length(:title, min: 1, max: 255)
    |> validate_length(:label, min: 1, max: 10)
    |> validate_format(:label, ~r/^[A-Z][0-9]*$/, message: "label deve ser letra maiúscula (ex: A, B, C1)")
    |> validate_number(:time_limit_ms, greater_than: 0, less_than_or_equal_to: 30_000)
    |> validate_number(:memory_limit_mb, greater_than: 0, less_than_or_equal_to: 1024)
    |> validate_number(:position, greater_than_or_equal_to: 0)
    |> validate_format(:color, ~r/^#[0-9a-fA-F]{6}$/, message: "deve ser hex (#RRGGBB)")
    |> unique_constraint([:contest_id, :label], message: "label já existe neste contest")
    |> assoc_constraint(:contest)
  end
end
