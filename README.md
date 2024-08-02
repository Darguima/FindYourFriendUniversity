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

With this Python script you will be able to scrape real personal data from DGES website. Although this is illegal due GDPR in Europe. Be careful when dealing with others personal information online.

When I started this project, I started it just as a POC, and after I wanted to learn Elixir and I decided take this project to other level. I would never publish others personal information online without their consent.

## Demo 📹

Here you can see a demo over the real data from DGES (only showing me), and then the complete Website Frontend with fake data. You can also see a screenshot of the website responsiveness on mobile phones.

https://github.com/Darguima/FindYourFriendUniversity/assets/49988070/96e2d543-7a87-420c-812d-2a01a697c27f

![](./readme/mobile-phone-demo.png)

## Getting Started

Below, you have the instructions to run the project in development and deployment mode. Choose the one that fits you better.

### 1. Scraping or Faking Students Data

Let's start by getting the seeds to populate the database. You can choose use faked data or scrape the real data from DGES. For both ways you have a python script to do that. On the next steps, DGES seeds will be always preferred over the faked seeds, if they exist.

If you are thinking about scraping the data take in mind that this is the slowest option, you will need install the `beautifulsoup4` package and scrape real data can go against the GDPR.

```bash
# Generate fake seeds to `./priv/repo/seeds.json`
$ python faker_seeds.py

# Scraping the official data from DGES to `./applications.json`
$ pip install beautifulsoup4
$ python applications_scraper.py
```

### 2.1 Development Server

Start by installing [`asdf`](https://asdf-vm.com/guide/getting-started.html). Now you can install Elixir and Erlang:

```bash
$ asdf install
```

Then you need create the Database. I like to use Docker for that:

```bash
$ docker run --name postgres -e POSTGRES_PASSWORD=postgres -p 5432:5432 -d postgres

# Start the container at computer startup
$ docker run --restart=always --name postgres -e POSTGRES_PASSWORD=postgres -p 5432:5432 -d postgres
```

Now you can run the migrations and start the Phoenix server:

```bash
$ mix setup
$ mix phx.server
```

And the server will be running at [`localhost:4000`](http://localhost:4000).

### 2.2 Deployment Server

To deploy the server I prepared a Docker Container to easily deploy it anywhere. Edit the `./docker/.env` file with your environment variables and run the following commands:

```bash
docker compose -f docker/docker-compose.yml up --build
```

Now you can access the server at the localhost on the port you defined in the `.env` file.

Now you need to populate the database. If you have scraped the data from DGES, it will be used; otherwise, fake data will be used. If at the build time you didn't have the DGES seeds, you can copy them now.

```bash
# Run just to copy the DGES seeds file, if it wasn't present at the build time
docker cp ./applications.json fyfu_app:/app/applications.json

# Run the seeds
docker exec -it fyfu_app mix ecto.setup
```

To completely remove the container and the volumes, run:

```bash
docker compose -f docker/docker-compose.yml down -v
```

## Walkthrough 🗺️

This is my first "big" Phoenix project, so I decided let a [walkthrough ](./WALKTHROUGH.md) about what I did.

### Learn more about Elixir / Phoenix 📚

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
