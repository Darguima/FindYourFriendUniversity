defmodule FindYourFriendUniversity.Repo.Migrations.CreateUniversities do
  use Ecto.Migration

  def change do
    create table(:universities) do
      add :name, :string
      add :code_id, :string, size: 4 # Just because in courses codes need be string
      add :is_polytechnic, :boolean, default: false, null: false

      timestamps()
    end
  end
end
