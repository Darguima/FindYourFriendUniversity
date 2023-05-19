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

### Access database

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
