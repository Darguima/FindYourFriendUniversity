defmodule FindYourFriendUniversityWeb.UniversityHTML do
  use FindYourFriendUniversityWeb, :html

  embed_templates "university_html/*"

  @doc """
  Renders a university form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def university_form(assigns)
end
