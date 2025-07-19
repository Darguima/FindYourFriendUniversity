defmodule FindYourFriendUniversity.Repo.Migrations.CreateLocations do
  use Ecto.Migration

  def change do
    create table(:locations) do
      add :name, :string, null: false
      add :civil_id, :string, null: false, size: 8
      add :year, :string, null: false, size: 4

      add :parish_id, references(:parishes, on_delete: :delete_all, on_update: :update_all, type: :string)

      timestamps()
    end

    create index(:locations, [:name])
    create index(:locations, [:civil_id])

    create unique_index(:locations, [:name, :civil_id, :parish_id, :year])
  end
end
