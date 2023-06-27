defmodule FindYourFriendUniversity.Repo.Migrations.CreateStudents do
  use Ecto.Migration

  def change do
    create table(:students, primary_key: false) do
      add :id, :string, primary_key: true, null: false # civil_id <> display_name
      add :name, :string, null: false
      add :display_name, :string, null: false
      add :civil_id, :string, null: false, size: 8

      timestamps()
    end

    create unique_index(:students, [:id])
  end
end
