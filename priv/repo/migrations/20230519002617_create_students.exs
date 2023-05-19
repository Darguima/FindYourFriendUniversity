defmodule FindYourFriendUniversity.Repo.Migrations.CreateStudents do
  use Ecto.Migration

  def change do
    create table(:students) do
      add :name, :string
      add :display_name, :string
      add :civil_id, :string

      timestamps()
    end
  end
end
