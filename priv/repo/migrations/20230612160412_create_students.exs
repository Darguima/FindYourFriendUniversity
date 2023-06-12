defmodule FindYourFriendUniversity.Repo.Migrations.CreateStudents do
  use Ecto.Migration

  def change do
    create table(:students, primary_key: false) do
      add :id, :string, primary_key: true # civil_id <> display_name
      add :name, :string
      add :display_name, :string
      add :civil_id, :string

      timestamps()
    end
  end
end
