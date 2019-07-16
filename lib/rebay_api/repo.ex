defmodule RebayApi.Repo do
  use Ecto.Repo,
    otp_app: :rebay_api,
    adapter: Ecto.Adapters.Postgres
end
