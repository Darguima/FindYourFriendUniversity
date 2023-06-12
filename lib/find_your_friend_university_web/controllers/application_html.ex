defmodule FindYourFriendUniversityWeb.ApplicationHTML do
  use FindYourFriendUniversityWeb, :html

  embed_templates "application_html/*"

  @doc """
  Renders a application form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def application_form(assigns)
end
