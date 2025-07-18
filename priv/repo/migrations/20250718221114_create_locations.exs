defmodule FindYourFriendUniversity.Repo.Migrations.CreateLocations do
  use Ecto.Migration

  def change do
    create table(:locations) do
      add :name, :string
      add :civil_id, :string
      add :parish_id, :string

      timestamps()
    end

    create unique_index(:locations, [:name, :civil_id, :parish_id])
  end
end
