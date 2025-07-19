defmodule FindYourFriendUniversity.Repo.Migrations.CreateCounties do
  use Ecto.Migration

  def change do
    create table(:counties, primary_key: false) do
      add :id, :string, primary_key: true, null: false, size: 3
      add :name, :string
      add :district_id, references(:districts, on_delete: :delete_all, on_update: :update_all, type: :string)

      timestamps()
    end

    create index(:counties, [:district_id])

    create unique_index(:counties, [:id])
    create unique_index(:counties, [:district_id, :name])
  end
end
