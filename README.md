# TaskApi

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

# Deploy
mix edeliver build release production --verbose
mix edeliver deploy release to production
mix edeliver start production

# Migrations
mix edeliver show migrations on production # shows pending database migrations
mix edeliver migrate production # run database migrations

# Start / Stop / Restart
mix edeliver start production 
mix edeliver stop production 
mix edeliver restart production

# Status
mix edeliver ping production # shows which nodes are up and running
mix edeliver version production # shows the release version running on the nodes
