# FindYourFriendUniversity

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

## Walkthrough

This is my first big Phoenix project, so I decided let here what I did.

### Create the project

I already had this folder created, so I ran:

```bash
$ mix local.hex\n
$ mix archive.install hex phx_new\n
$ mix phx.new . --app find_your_friend_university --module FindYourFriendUniversity
```

### Create and Access database

To create the database:

```bash
$ docker run --name postgres -e POSTGRES_PASSWORD=postgres -p 5432:5432 -d postgres
```

To access database

```bash
$ psql -h localhost -p 5432 -U postgres
>>> \l
>>> \c find_your_friend_university_dev
>>> \dt
>>> SELECT * FROM <table_name>;
```
