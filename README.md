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

### Create and Access database

To create database

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

### Contexts

```bash
$ mix phx.gen.html Students Student students name:string display_name:string civil_id:string
$ mix phx.gen.html Courses Course courses name:string code_id:integer
$ mix phx.gen.html Universities University universities name:string code_id:integer is_polytechnic:boolean
```

### Many to Many Tables

Added to Universities Schema

```elixir
many_to_many :courses, Course, join_through: "universities_courses"
```

Created the join table migration and edited them.

```bash
$ mix ecto.gen.migration create_universities_courses
```

To receive and link the Courses that the Universities have, and store them on the relation table I followed this [post](https://dev.to/ricardoruwer/many-to-many-associations-in-elixir-and-phoenix-21pm).
