defmodule FindYourFriendUniversity.Repo.Migrations.CreateApplications do
  use Ecto.Migration

  def change do
    create table(:applications) do
      add :course_order_num, :integer, null: false
      add :candidature_grade, :integer, null: false
      add :exams_grades, :integer, null: false
      add :_12grade, :integer, null: false
      add :_11grade, :integer, null: false
      add :student_option_number, :integer, null: false
      add :placed, :boolean, default: false, null: false
      add :year, :integer, null: false
      add :phase, :integer, null: false

      add :university_id, references(:universities, on_delete: :delete_all, on_update: :update_all, type: :string)
      add :course_id, references(:courses, on_delete: :delete_all, on_update: :update_all, type: :string)
      add :student_id, references(:students, on_delete: :delete_all, on_update: :update_all, type: :string)

      timestamps()
    end

    create index(:applications, [:university_id])
    create index(:applications, [:course_id])
    create index(:applications, [:student_id])

    # To prevent duplicated candidatures - conflicts will be ignored
    create unique_index(:applications, [:student_id, :year, :phase, :student_option_number, :university_id, :course_id])
  end
end
