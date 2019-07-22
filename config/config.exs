# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :rebay_api,
  ecto_repos: [RebayApi.Repo]

# Configures the endpoint
config :rebay_api, RebayApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "57YD+QTmHAkxtH4WWg3CI+wldeYub2mU2a2A1aKFA/wAx/0cuN6z/uZy9i9yh7fm",
  render_errors: [view: RebayApiWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: RebayApi.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :ueberauth, Ueberauth,
  providers: [
    google: {Ueberauth.Strategy.Google, [] }
  ]

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: System.get_env("GOOGLE_CLIENT_ID"),
  client_secret: System.get_env("GOOGLE_CLIENT_SECRET")
