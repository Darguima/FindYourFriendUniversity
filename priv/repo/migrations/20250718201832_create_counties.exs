defmodule FindYourFriendUniversity.Repo.Migrations.CreateCounties do
  use Ecto.Migration

  def change do
    create table(:counties, primary_key: false) do
      add :id, :string, primary_key: true
      add :name, :string
      add :district_id, :string

      timestamps()
    end
  end
end
