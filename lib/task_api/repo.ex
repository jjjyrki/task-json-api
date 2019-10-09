defmodule TaskApi.Repo do
  use Ecto.Repo,
    otp_app: :task_api,
    adapter: Ecto.Adapters.Postgres
end
