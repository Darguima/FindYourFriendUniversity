defmodule FindYourFriendUniversity.Repo.Migrations.CreateCourses do
  use Ecto.Migration

  def change do
    create table(:courses, primary_key: false) do
      add :id, :string, primary_key: true, null: false, size: 4
      add :name, :string, null: false

      timestamps()
    end

    create unique_index(:courses, [:id])
  end
end
