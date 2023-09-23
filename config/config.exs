# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :undi, :env, Mix.env()

config :undi,
  ecto_repos: [Undi.Repo],
  generators: [binary_id: true]

config :undi, Undi.Repo,
  migration_primary_key: [name: :id, type: :binary_id]


# Configures the endpoint
config :undi, UndiWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: UndiWeb.ErrorHTML, json: UndiWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Undi.PubSub,
  live_view: [signing_salt: "oF5QltnE"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :undi, Undi.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.3.2",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :undi, Undi.Admins.Guardian,
  issuer: "undi",
  secret_key: System.get_env("GUARDIAN_SECRET_KEY_ADMINS") || "nUetaelL6zcgy/mVLv1S3oJQyMKkAKLB8wp4xdPNcq+elbySVppFb79K9zBzH8e7"


# This implements Ueberauth with the Github Strategy.
# There are other strategies like Twitter, Google, Apple and Facebook.
# Read more in the Ueberauth docs.
config :ueberauth, Ueberauth,
  providers: [
    github: {Ueberauth.Strategy.Github, [default_scope: "user:email"]}
  ]

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: System.get_env("GITHUB_CLIENT_ID"),
  client_secret: System.get_env("GITHUB_CLIENT_SECRET")


config :undi, Oban,
  repo: Undi.Repo,
  queues: [default: 10, mailers: 20, high: 50, low: 5],
  plugins: [
    {Oban.Plugins.Pruner, max_age: (3600 * 24)},
    {Oban.Plugins.Cron,
      crontab: [
        {"0 9 * * *", Undi.Campaigns.ExecuteStepWorker},
       # {"0 2 * * *", Undi.Workers.DailyDigestWorker},
       # {"@reboot", Undi.Workers.StripeSyncWorker},
       # {"0 2 * * *", Undi.DailyReports.DailyReportWorker},
     ]}
  ]
config :flop, repo: Undi.Repo
config :undi, Undi.Admins.Guardian,
  issuer: "undi",
  secret_key: System.get_env("GUARDIAN_SECRET_KEY_ADMINS") || "0aMB+PerCYQ7dc51X7yGfHS9sYfVTEC6SZmIZ4UH1j3UbJOsf/1hFyU1NB9XXerD"

config :stripity_stripe,
  api_key: System.get_env("STRIPE_SECRET"),
  public_key: System.get_env("STRIPE_PUBLIC"),
  webhook_signing_key: System.get_env("STRIPE_WEBHOOK_SIGNING_KEY")


config :waffle,
  storage: Waffle.Storage.S3, # or Waffle.Storage.Local
  bucket: System.get_env("AWS_BUCKET") # if using S3

config :ex_aws,
  json_codec: Jason,
  access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
  secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
  region: System.get_env("AWS_REGION")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
