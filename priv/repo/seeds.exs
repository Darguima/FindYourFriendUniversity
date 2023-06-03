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

Enum.each([
  %{name: "Engenharia de Polímeros", code_id: "L229"},
  %{name: "Engenharia Civil", code_id: "9089"},
  %{name: "Engenharia Informática", code_id: "9119"},
  %{name: "Engenharia Física", code_id: "9113"},
  %{name: "Engenharia Têxtil", code_id: "9127"},
  %{name: "Engenharia Aeronáutica", code_id: "9740"},
], fn course -> Courses.create_course(course) end)

Enum.each([
  %{name: "Universidade do Minho", code_id: "1000", courses_ids: [2, 3]},
  %{name: "Universidade de Aveiro", code_id: "0300", courses_ids: [2, 3, 4, 5]},
  %{name: "Universidade do Porto - Faculdade de Engenharia", code_id: "1105", courses_ids: [2, 4, 5]},
  %{name: "ISCTE - Instituto Universitário de Lisboa", code_id: "6800", courses_ids: [1, 2, 3, 4, 5, 6]},
  %{name: "Instituto Politécnico de Viana do Castelo - Escola Superior de Tecnologia e Gestão", code_id: "3163", is_polytechnic: true, courses_ids: [1, 2, 3, 6]},
  %{name: "Instituto Politécnico de Viseu - Escola Superior de Tecnologia e Gestão de Viseu", code_id: "3182", is_polytechnic: true},
], fn uni -> Universities.create_university(uni) end)
