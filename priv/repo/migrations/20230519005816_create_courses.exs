defmodule FindYourFriendUniversity.Repo.Migrations.CreateCourses do
  use Ecto.Migration

  def change do
    create table(:courses) do
      add :name, :string
      add :code_id, :integer

      timestamps()
    end
  end
end
