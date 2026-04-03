defmodule Syncrojudge.Repo do
  use Ecto.Repo,
    otp_app: :syncrojudge,
    adapter: Ecto.Adapters.Postgres
end
