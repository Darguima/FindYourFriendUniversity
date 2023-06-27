defmodule FindYourFriendUniversity.Repo.Migrations.CreateUniversities do
  use Ecto.Migration

  def change do
    create table(:universities, primary_key: false) do
      add :id, :string, primary_key: true, null: false, size: 4
      add :name, :string, null: false
      add :is_polytechnic, :boolean, default: false, null: false

      timestamps()
    end

    create unique_index(:universities, [:id])
  end
end
