import Config

config :syncrojudge,
  ecto_repos: [Syncrojudge.Repo]

config :syncrojudge, Syncrojudge.Repo,
  database: "syncrojudge_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"
