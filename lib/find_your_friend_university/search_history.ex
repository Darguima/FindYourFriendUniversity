defmodule FindYourFriendUniversity.SearchHistory do
  alias FindYourFriendUniversity.SearchHistory
  alias FindYourFriendUniversity.Repo

  use Ecto.Schema
  import Ecto.Changeset

  schema "searches_history" do
    field(:name, :string)
    field(:civil_id, :string)

    field(:courses_applications, {:array, :string})
    field(:universities_applications, {:array, :string})

    field(:years_applications, {:array, :string})
    field(:phases_applications, {:array, :string})

    timestamps()
  end

  @doc false
  def changeset(search_history, attrs) do
    search_history
    |> cast(attrs, [
      :name,
      :civil_id,
      :universities_applications,
      :courses_applications,
      :years_applications,
      :phases_applications
    ])
    |> validate_required([
      :universities_applications,
      :courses_applications,
      :years_applications,
      :phases_applications
    ])
    |> validate_length(:civil_id, greater_than_or_equal_to: 7, less_than_or_equal_to: 8)
  end

  def create_search_history(attrs \\ %{}) do
    %SearchHistory{}
    |> SearchHistory.changeset(attrs)
    |> Repo.insert()
  end
end
