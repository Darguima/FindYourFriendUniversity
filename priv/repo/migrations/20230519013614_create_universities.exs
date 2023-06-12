defmodule FindYourFriendUniversity.Repo.Migrations.CreateUniversities do
  use Ecto.Migration

  def change do
    create table(:universities, primary_key: false) do
      add :name, :string
      add :id, :string, size: 4, primary_key: true # Just because in courses codes need be string
      add :is_polytechnic, :boolean, default: false, null: false

      timestamps()
    end

    create unique_index(:universities, [:id])
  end
end
