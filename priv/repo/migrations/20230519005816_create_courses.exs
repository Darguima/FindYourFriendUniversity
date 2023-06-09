defmodule FindYourFriendUniversity.Repo.Migrations.CreateCourses do
  use Ecto.Migration

  def change do
    create table(:courses, primary_key: false) do
      add :name, :string
      add :id, :string, size: 4, primary_key: true # Some codes have the letter L

      timestamps()
    end

    create unique_index(:courses, [:id])
  end
end
