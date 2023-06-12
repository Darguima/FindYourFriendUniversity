defmodule FindYourFriendUniversity.Repo.Migrations.CreateCourses do
  use Ecto.Migration

  def change do
    create table(:courses, primary_key: false) do
      add :id, :string, primary_key: true
      add :name, :string

      timestamps()
    end
  end
end
