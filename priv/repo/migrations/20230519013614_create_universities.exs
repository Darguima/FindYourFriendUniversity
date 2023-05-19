defmodule FindYourFriendUniversity.Repo.Migrations.CreateUniversities do
  use Ecto.Migration

  def change do
    create table(:universities) do
      add :name, :string
      add :code_id, :integer
      add :is_polytechnic, :boolean, default: false, null: false

      timestamps()
    end
  end
end
