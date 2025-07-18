defmodule FindYourFriendUniversity.Repo.Migrations.CreateParishes do
  use Ecto.Migration

  def change do
    create table(:parishes, primary_key: false) do
      add :id, :string, primary_key: true
      add :name, :string
      add :county_id, :string

      timestamps()
    end
  end
end
