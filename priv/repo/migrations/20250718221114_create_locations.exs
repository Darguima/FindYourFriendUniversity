defmodule FindYourFriendUniversity.Repo.Migrations.CreateLocations do
  use Ecto.Migration

  def change do
    create table(:locations) do
      add :name, :string, null: false
      add :civil_id, :string, null: false, size: 8
      add :parish_id, :string, null: false
      add :year, :string, null: false, size: 4

      timestamps()
    end

    create unique_index(:locations, [:name, :civil_id, :parish_id, :year])
  end
end
