defmodule FindYourFriendUniversityWeb.CourseHTML do
  use FindYourFriendUniversityWeb, :html

  embed_templates "course_html/*"

  @doc """
  Renders a course form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def course_form(assigns)
end
