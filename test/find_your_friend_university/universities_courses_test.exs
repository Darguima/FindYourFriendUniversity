defmodule FindYourFriendUniversity.UniversitiesCoursesTest do
  use FindYourFriendUniversity.DataCase

  describe "universities_courses" do
    alias FindYourFriendUniversity.Universities
    alias FindYourFriendUniversity.Universities.University
    alias FindYourFriendUniversity.Courses
    alias FindYourFriendUniversity.Courses.Course

    import FindYourFriendUniversity.UniversitiesFixtures
    import FindYourFriendUniversity.CoursesFixtures

    @valid_uni_attrs %{id: "_id_", is_polytechnic: true, name: "some name"}
    @valid_course_attrs %{id: "_id_", name: "some name"}

    test "create_university/1 with valid data and course association creates a university" do
      course = course_fixture()

      valid_uni_attrs = @valid_uni_attrs
      |> Map.merge(%{
        courses: [course]
      })

      assert {:ok, %University{} = university} = Universities.create_university(valid_uni_attrs)

      assert university.id == "_id_"
      assert university.is_polytechnic == true
      assert university.name == "some name"
      assert university.courses == [course]
    end

    test "create_course/1 with valid data and university association creates a course" do
      university = university_fixture()

      valid_course_attrs = @valid_course_attrs
      |> Map.merge(%{
        universities: [university]
      })

      assert {:ok, %Course{} = course} = Courses.create_course(valid_course_attrs)

      assert course.id == "_id_"
      assert course.name == "some name"
      assert course.universities == [university]
    end
  end
end
