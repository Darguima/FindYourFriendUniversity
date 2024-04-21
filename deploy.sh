#!/bin/bash
set -e

if [ -z "${DB_USER}" ]; then
	read -p "Postgres DB Username (default 'postgres'): " user_input
	DB_USER=${user_input:-"postgres"}
else
  echo "Postgres DB Username: $DB_USER"
fi

if [ -z "${DB_PASS}" ]; then
	read -sp "Postgres DB Password (default 'postgres'): " pass_input
	DB_PASS=${pass_input:-"postgres"}
else
  echo "Postgres DB Password: <hidden>"
fi

if [ -z "${RUN_SEEDS}" ]; then
	read -p $'\nDo you want run seeds [y / N] : ' seeds_input
	RUN_SEEDS=${seeds_input:-"N"}
else
  echo "Do you want run seeds [y / n] : $RUN_SEEDS"
fi

echo

echo ">>> Preparing ENV Variables"
export SECRET_KEY_BASE=$(mix phx.gen.secret)
export DATABASE_URL=ecto://$DB_USER:$DB_PASS@localhost/find_your_friend_university

echo ">>> Installing dependencies"
mix deps.get

echo ">>> Compiling project"
MIX_ENV=prod mix compile
MIX_ENV=prod mix assets.deploy

echo ">>> Preparing DB"
MIX_ENV=prod mix ecto.create
MIX_ENV=prod mix ecto.migrate

if [[ "${RUN_SEEDS,,}" == "y" ]]; then
	echo ">>> Running Seeds"
	MIX_ENV=prod mix run priv/repo/seeds.exs
else
	echo ">>> Skipping Seeds"
fi

echo ">>> Running the Web Server"
MIX_ENV=prod elixir --erl "-detached" -S mix phx.server
