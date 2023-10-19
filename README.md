<h2 align="center">
	FindYourFriendUniversity
</h2>

<p align="center">
FindYourFriendUniversity is an Elixir Phoenix App, that alongside a Python script, indexes all the candidatures and collocations of all the students that were already candidates to Portuguese Public Universities.
</p>

<h4 align="center">
⭐ Don't forget to Starring ⭐
</h4>

#### ⚠️ Disclaimer - GDPR 🔒🧍

With this Python script you will be able to scrape real personal data from DGES website. Although this is illegal due GDPR in Europe. Be careful when dealing with others personal information online

When I started this project, I started it just as a POC, and after I wanted to learn Elixir and I decided take this project to other level. I would never publish others personal information online without their consent.

## Demo 📹

Here you can see a demo with all the real data from DGES (only showing me), and then the complete Website Frontend with fake data. You can also see a screenshot of the website responsiveness on mobile phones.

###### If the player fails click [here for real data demo](./readme/real-data-demo.mp4) and [here for fake data](./readme/fake-data-demo.mp4).

https://github.com/Darguima/FindYourFriendUniversity/assets/49988070/7acd0292-87f1-4775-b623-c10eacf33e62

https://github.com/Darguima/FindYourFriendUniversity/assets/49988070/9cd12753-a2c2-430b-88f4-2698b1e4e698

![](./readme/mobile-phone-demo.png)

## Contribute

To start your Phoenix server:

  * Create fake seeds with `python faker_seeds.py` or scrape the official data from DGES `python applications_scraper.py` (after `pip install beautifulsoup4`)
  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [Phoenix deployment guides](https://hexdocs.pm/phoenix/deployment.html).

### Learn more about Elixir / Phoenix 📚

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

### To Do 🗹

1. Configure Postgres to be secure - I'm using default password
2. Add Footer

### Walkthrough 🗺️

This is my first "big" Phoenix project, so I decided let here what I did.

#### Create the project

I already had this folder created, so I ran:

```bash
$ mix local.hex
$ mix archive.install hex phx_new
$ mix phx.new . --app find_your_friend_university --module FindYourFriendUniversity
```

#### Create and Access database

To create the database:

```bash
$ docker run --name postgres -e POSTGRES_PASSWORD=postgres -p 5432:5432 -d postgres

# Start the container at computer startup
$ docker run --restart=always --name postgres -e POSTGRES_PASSWORD=postgres -p 5432:5432 -d postgres
```

To access database

```bash
$ psql -h localhost -p 5432 -U postgres
>>> \l
>>> \c find_your_friend_university_dev
>>> \dt
>>> SELECT * FROM <table_name>;
```

##### Working with env variables to store credentials

If you want, you can store the credentials inside `DB_USER` and `DB_PASS` env variables and then pass them to Phoenix:

```bash
$ read USER
$ read -s PASS
$ DB_PASS=$PASS DB_USER=$USER mix phx.server
```

#### Migrations and Schemas

I generated my migrations, schemas and all the HTML files with this commands. Then I did some modifications, like turn off some ids that were autogenerated on the migrations and schemas, to receive them on the changeset.

```bash
$ mix phx.gen.html Students Student students id:string name:string display_name:string civil_id:string
$ mix phx.gen.html Courses Course courses id:string name:string
$ mix phx.gen.html Universities University universities id:string name:string is_polytechnic:boolean
$ mix phx.gen.html Applications Application applications course_order_num:integer candidature_grade:integer exams_grades:integer _12grade:integer _11grade:integer student_option_number:integer placed:boolean year:integer phase:integer university_id:references:universities course_id:references:courses student_id:references:students
```

#### Many to Many Tables

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

#### Deploy 🚀

And at the final I wanted to learn how to deploy on my home server this app [remember that do this is illegal, this was just a test]. After research and tries, I ended writing a script to automatize this task (can be used in any Phoenix Project without major changes).

Run it and fill the firsts questions. After some seconds you will have a deployed Web Server running at `http://127.0.0.1:4000/`. Now use some tool like NGinx to expose it to the Internet.

###### You shouldn't directly expose port 80/443 with web servers, because this are high privileges ports.

```bash
$ ./deploy.sh
```

If for some reason you want pass some Phoenix Env Variables you can pass it to the script and them will be passed to Phoenix. For example, if you want the app running under the path `example.com/fyfu`, you can run:

```bash
$ PHX_PATH='/fyfu' ./deploy.sh
```
 