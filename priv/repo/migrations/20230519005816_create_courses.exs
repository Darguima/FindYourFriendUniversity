defmodule FindYourFriendUniversity.Repo.Migrations.CreateCourses do
  use Ecto.Migration

  def change do
    create table(:courses) do
      add :name, :string
      add :code_id, :string, size: 4 # Some codes have the letter L

      timestamps()
    end
  end
end
