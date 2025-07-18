defmodule FindYourFriendUniversity.Repo.Migrations.CreateParishes do
  use Ecto.Migration

  def change do
    create table(:parishes, primary_key: false) do
      add :id, :string, primary_key: true, null: false, size: 4
      add :name, :string
      add :county_id, :string

      timestamps()
    end

    create unique_index(:parishes, [:id])
    create unique_index(:parishes, [:county_id, :name])
  end
end
