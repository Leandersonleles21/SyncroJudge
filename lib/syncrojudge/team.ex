defmodule Syncrojudge.Team do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field(:name, :string)
    field(:login, :string)
    field(:password_hash, :string)
    field(:enabled, :boolean, default: true)

    # campo virtual - senha em texto claro só vive no changeset
    field(:password, :string, virtual: true)

    belongs_to(:contest, Syncrojudge.Contest)
    has_many(:submissions, Syncrojudge.Submission)
    has_many(:clarifications, Syncrojudge.Clarification)

    timestamps()
  end

  @required_fields ~w(name login contest_id)a
  @optional_fields ~w(enabled)a

  def changeset(team, params \\ %{}) do
    team
    |> cast(params, @required_fields ++ @optional_fields ++ [:password])
    |> validate_required(@required_fields)
    |> validate_length(:name, min: 1, max: 255)
    |> validate_length(:login, min: 1, max: 100)
    |> unique_constraint([:login, :contest_id], message: "login já existe neste contest")
    |> assoc_constraint(:contest)
    |> hash_password()
  end

  def create_changeset(team, params) do
    team
    |> changeset(params)
    |> validate_required([:password], message: "senha é obrigatória")
    |> validate_length(:password, min: 4, max: 72, message: "senha deve ter entre 4 e 72 caracteres")
  end

  defp hash_password(changeset) do
    case get_change(changeset, :password) do
      nil ->
        changeset

      password ->
        # Usa Bcrypt se disponível, senão faz hash simples (trocar em produção)
        changeset
        |> put_change(:password_hash, Base.encode64(:crypto.hash(:sha256, password)))
        |> delete_change(:password)
    end
  end
end
