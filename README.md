# RebayApi

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

## Setting up Environment Variables + Starting Local Server
-  Create a .env file in your root and add the following
```
export GOOGLE_CLIENT_ID="Get from Teammate"
export GOOGLE_CLIENT_SECRET="Get from Teammate"
export CLIENT_HOST=http://localhost:<client_port>
```
- `source .env`
- `mix phx.server`

# Seeding Postgres Data
`mix ecto.migrate`
`mix run priv/repo/seeds.exs`

# When changing the schema or migration files, run:
```
mix ecto.rollback
mix ecto.migrate
mix run priv/repo/seeds.exs
```

## Deployment with Heroku CLI
```
git push heroku feature/add_bid:master --push
```

If you hit `{"errors":{"detail":"Not Found"}}`:
```
heroku run "POOL_SIZE=2 mix ecto.migrate"
heroku run "POOL_SIZE=2 mix run priv/repo/seeds.exs"
```

### If you need to drop the deployed database
```
heroku pg:reset
heroku run "POOL_SIZE=2 mix ecto.create"
heroku run "POOL_SIZE=2 mix ecto.migrate"
heroku run "POOL_SIZE=2 mix run priv/repo/seeds.exs"
```

### Generate a new API Token
`heroku authorizations:create`