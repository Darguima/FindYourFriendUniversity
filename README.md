# FindYourFriendUniversity

To start your Phoenix server:

  * Create fake seeds with `python faker_seeds.py` or scrape the official data from DGES `python scraper.py` 
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

## To Do

1. Configure Postgres to be secure - I'm using default password
2. Exclude unnecessary controllers

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

### Migrations and Schemas

I generated my migrations, schemas and all the HTML files with this commands. Then I did some modifications, like turn off some ids that were autogenerated on the migrations and schemas, to receive them on the changeset.

```bash
$ mix phx.gen.html Students Student students id:string name:string display_name:string civil_id:string
$ mix phx.gen.html Courses Course courses id:string name:string
$ mix phx.gen.html Universities University universities id:string name:string is_polytechnic:boolean
$ mix phx.gen.html Applications Application applications course_order_num:integer candidature_grade:integer exams_grades:integer _12grade:integer _11grade:integer student_option_number:integer placed:boolean year:integer phase:integer university_id:references:universities course_id:references:courses student_id:references:students
```

### Many to Many Tables

I created a table for the many to many association between Courses and Universities:

```bash
$ mix ecto.gen.migration create_universities_courses
```

And wrote this function on the migrations:

```elixir
  def change do
    create table(:universities_courses) do
      add :university_id, references(:universities, on_delete: :delete_all, on_update: :update_all, type: :string)
      add :course_id, references(:courses, on_delete: :delete_all, on_update: :update_all, type: :string)
    end

    create unique_index(:universities_courses, [:university_id, :course_id])
  end
```

And then added to Universities and Courses Schema

```elixir
many_to_many :courses, Course, join_through: "universities_courses" # universities.ex
many_to_many :universities, University, join_through: "universities_courses" # courses.ex
```

To put the associations on the table while running the changeset, I followed this [post](https://dev.to/ricardoruwer/many-to-many-associations-in-elixir-and-phoenix-21pm).
 