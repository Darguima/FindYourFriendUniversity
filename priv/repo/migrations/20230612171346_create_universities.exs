defmodule FindYourFriendUniversity.Repo.Migrations.CreateUniversities do
  use Ecto.Migration

  def change do
    create table(:universities, primary_key: false) do
      add :id, :string, primary_key: true
      add :name, :string
      add :is_polytechnic, :boolean, default: false, null: false

      timestamps()
    end
  end
end
