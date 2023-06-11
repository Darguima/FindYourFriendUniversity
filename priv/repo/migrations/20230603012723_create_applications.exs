defmodule FindYourFriendUniversity.Repo.Migrations.CreateApplications do
  use Ecto.Migration

  def change do
    create table(:applications) do
      add :course_order_num, :integer
      add :candidature_grade, :integer
      add :exams_grades, :integer
      add :_12grade, :integer
      add :_11grade, :integer
      add :student_option_number, :integer
      add :placed, :boolean, default: false, null: false
      add :year, :integer
      add :phase, :integer
      add :university_id, references(:universities, on_delete: :nothing, type: :string)
      add :course_id, references(:courses, on_delete: :nothing, type: :string)
      add :student_id, references(:students, on_delete: :nothing, type: :string)

      timestamps()
    end

    create index(:applications, [:university_id])
    create index(:applications, [:course_id])
    create index(:applications, [:student_id])
  end
end
