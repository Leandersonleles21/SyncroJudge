defmodule Syncrojudge.TestCase do
  use Ecto.Schema
  import Ecto.Changeset

  schema "test_cases" do
    field(:input_path, :string)
    field(:output_path, :string)
    field(:position, :integer)
    field(:is_sample, :boolean, default: false)

    belongs_to(:problem, Syncrojudge.Problem)

    timestamps()
  end

  @required_fields ~w(input_path output_path problem_id)a
  @optional_fields ~w(position is_sample)a

  def changeset(test_case, params \\ %{}) do
    test_case
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_length(:input_path, min: 1, max: 500)
    |> validate_length(:output_path, min: 1, max: 500)
    |> validate_number(:position, greater_than_or_equal_to: 0)
    |> assoc_constraint(:problem)
  end
end
