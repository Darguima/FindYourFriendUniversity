defmodule FindYourFriendUniversity.Repo.Migrations.CreateUniversityCourses do
  use Ecto.Migration

  def change do
    create table(:university_courses) do
      add :university_id, references(:universities, on_delete: :delete_all)
      add :course_id, references(:courses, on_delete: :delete_all)
    end

    create unique_index(:university_courses, [:university_id, :course_id])
  end

end
