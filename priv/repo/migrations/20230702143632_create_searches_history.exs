defmodule FindYourFriendUniversity.Repo.Migrations.CreateSearchesHistory do
  use Ecto.Migration

  def change do
    create table(:searches_history) do
      add(:name, :string)
      add(:civil_id, :string, size: 8)

      add(:universities_applications, {:array, :string}, null: false)
      add(:courses_applications, {:array, :string}, null: false)

      add(:years_applications, {:array, :string}, null: false)
      add(:phases_applications, {:array, :string}, null: false)
      timestamps()
    end
  end
end
