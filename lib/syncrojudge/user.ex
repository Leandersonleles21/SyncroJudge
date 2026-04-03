defmodule Syncrojudge.User do
  use Ecto.Schema
  import Ecto.Changeset

  @roles ~w(admin judge)

  schema "users" do
    field(:name, :string)
    field(:email, :string)
    field(:password_hash, :string)
    field(:role, :string, default: "judge")
    field(:active, :boolean, default: true)

    # campo virtual — senha em texto claro só existe no changeset
    field(:password, :string, virtual: true)

    timestamps()
  end

  @required_fields ~w(name email)a
  @optional_fields ~w(role active)a

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, @required_fields ++ @optional_fields ++ [:password])
    |> validate_required(@required_fields)
    |> validate_length(:name, min: 1, max: 255)
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+\.[^\s]+$/, message: "email inválido")
    |> validate_inclusion(:role, @roles, message: "deve ser: admin ou judge")
    |> unique_constraint(:email, message: "email já cadastrado")
  end

  def create_changeset(user, params) do
    user
    |> changeset(params)
    |> validate_required([:password], message: "senha é obrigatória")
    |> validate_length(:password, min: 6, max: 72, message: "senha deve ter entre 6 e 72 caracteres")
    |> hash_password()
  end

  defp hash_password(changeset) do
    case get_change(changeset, :password) do
      nil ->
        changeset

      password ->
        changeset
        |> put_change(:password_hash, Bcrypt.hash_pwd_salt(password))
        |> delete_change(:password)
    end
  end
end
