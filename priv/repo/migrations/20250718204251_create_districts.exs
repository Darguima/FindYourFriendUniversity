defmodule FindYourFriendUniversity.Repo.Migrations.CreateDistricts do
  use Ecto.Migration

  def change do
    create table(:districts, primary_key: false) do
      add :id, :string, primary_key: true, null: false, size: 2
      add :name, :string

      timestamps()
    end

    create unique_index(:districts, [:id])
    create unique_index(:districts, [:name])
  end
end
