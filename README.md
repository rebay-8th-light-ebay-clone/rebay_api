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

## Setting up Environment Variables
-  Create a .env file in your root and add the following
```
export GOOGLE_CLIENT_ID="Get from Teammate"
export GOOGLE_CLIENT_SECRET="Get from Teammate"
export CLIENT_HOST=http://localhost:<client_port>
```
- `source .env`

# Seeding Postgres Data
`mix ecto.migrate`
`mix run priv/repo/seeds.exs`

# When changing the schema or migration files, run:
```
mix ecto.rollback
mix ecto.migrate
mix run priv/repo/seeds.exs
```

## Deployment
Environmental Variables ($HEROKU_API_KEY and $HEROKU_APP_NAME) for Deployment are stored in CircleCI.

### Generate a new API Token
`heroku authorizations:create`

###$ [Setting an Environment Variable in a CircleCI Project](https://circleci.com/docs/2.0/env-vars/#setting-an-environment-variable-in-a-project)
In the CircleCI application, go to your project’s settings by clicking the gear icon next to your project.

In the Build Settings section, click on Environment Variables.

Import variables from another project by clicking the Import Variable(s) button. Add new variables by clicking the Add Variable button. (Note: The Import Variables(s) button is not currently available on CircleCI installed in your private cloud or datacenter.)

Use your new environment variables in your .circleci/config.yml file. For an example, see the Heroku deploy walkthrough.

Once created, environment variables are hidden and uneditable in the application. Changing an environment variable is only possible by deleting and recreating it.


### After Heroku Deployment, If you receive a `500 Internal Server Error`
1. go to project directory and run `heroku run "POOL_SIZE=2 mix ecto.migrate"`
2. If your database is empty, you can add your seeds by running `heroku run "POOL_SIZE=2 mix run priv/repo/seeds.exs"`