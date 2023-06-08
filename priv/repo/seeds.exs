# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     FindYourFriendUniversity.Repo.insert!(%FindYourFriendUniversity.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias FindYourFriendUniversity.Courses
alias FindYourFriendUniversity.Universities
alias FindYourFriendUniversity.Students
alias FindYourFriendUniversity.Applications

Courses.create_courses([
  %{name: "Engenharia de Polímeros", code_id: "L229"},
  %{name: "Engenharia Civil", code_id: "9089"},
  %{name: "Engenharia Informática", code_id: "9119"},
  %{name: "Engenharia Física", code_id: "9113"},
  %{name: "Engenharia Têxtil", code_id: "9127"},
  %{name: "Engenharia Aeronáutica", code_id: "9740"}
])

Universities.create_universities([
  %{name: "Universidade do Minho", code_id: "1000", courses_ids: [2, 3]},
  %{name: "Universidade de Aveiro", code_id: "0300", courses_ids: [2, 3, 4, 5]},
  %{
    name: "Universidade do Porto - Faculdade de Engenharia",
    code_id: "1105",
    courses_ids: [2, 4, 5]
  },
  %{
    name: "ISCTE - Instituto Universitário de Lisboa",
    code_id: "6800",
    courses_ids: [1, 2, 3, 4, 5, 6]
  },
  %{
    name: "Instituto Politécnico de Viana do Castelo - Escola Superior de Tecnologia e Gestão",
    code_id: "3163",
    is_polytechnic: true,
    courses_ids: [1, 2, 3, 6]
  },
  %{
    name: "Instituto Politécnico de Viseu - Escola Superior de Tecnologia e Gestão de Viseu",
    code_id: "3182",
    is_polytechnic: true
  }
])

Students.create_students([
  %{name: "Mike Obama", display_name: "dariojosesilvaguimaraes", civil_id: "123xxx45"},
  %{name: "Maria João Oliveira", display_name: "mariajoaooliveira", civil_id: "567xxx89"},
  %{name: "João Pedro Santos", display_name: "joaopedrosantos", civil_id: "101xxx11"},
  %{name: "Ana Luísa Sousa", display_name: "analuisasousa", civil_id: "234xxx56"},
  %{name: "Pedro Miguel Almeida", display_name: "pedromiguelalmeida", civil_id: "789xxx01"},
  %{name: "Sofia Isabel Pereira", display_name: "sofiaisabelpereira", civil_id: "345xxx67"},
  %{name: "Miguel Ângelo Carvalho", display_name: "miguelangelocarvalho", civil_id: "890xxx12"},
  %{name: "Carolina Maria Silva", display_name: "carolinamariasilva", civil_id: "456xxx78"}
])

Applications.create_applications([
  %{
    course_order_num: 1,
    candidature_grade: 14,
    exams_grades: 15,
    _12grade: 16,
    _11grade: 14,
    student_option_number: 1,
    placed: true,
    year: 2018,
    phase: 1,
    university: 1,
    course: 1,
    student: 1
  },
  %{
    course_order_num: 2,
    candidature_grade: 13,
    exams_grades: 14,
    _12grade: 15,
    _11grade: 14,
    student_option_number: 2,
    placed: false,
    year: 2018,
    phase: 1,
    university: 5,
    course: 5,
    student: 1
  },
  %{
    course_order_num: 3,
    candidature_grade: 15,
    exams_grades: 14,
    _12grade: 15,
    _11grade: 14,
    student_option_number: 3,
    placed: true,
    year: 2018,
    phase: 1,
    university: 2,
    course: 2,
    student: 1
  },
  %{
    course_order_num: 4,
    candidature_grade: 14,
    exams_grades: 14,
    _12grade: 16,
    _11grade: 13,
    student_option_number: 1,
    placed: false,
    year: 2018,
    phase: 1,
    university: 6,
    course: 4,
    student: 2
  },
  %{
    course_order_num: 5,
    candidature_grade: 16,
    exams_grades: 14,
    _12grade: 15,
    _11grade: 14,
    student_option_number: 2,
    placed: true,
    year: 2018,
    phase: 1,
    university: 2,
    course: 1,
    student: 2
  },
  %{
    course_order_num: 6,
    candidature_grade: 14,
    exams_grades: 15,
    _12grade: 15,
    _11grade: 14,
    student_option_number: 1,
    placed: false,
    year: 2018,
    phase: 1,
    university: 1,
    course: 3,
    student: 3
  },
  %{
    course_order_num: 7,
    candidature_grade: 15,
    exams_grades: 14,
    _12grade: 15,
    _11grade: 14,
    student_option_number: 1,
    placed: true,
    year: 2018,
    phase: 1,
    university: 5,
    course: 5,
    student: 5
  }
])
