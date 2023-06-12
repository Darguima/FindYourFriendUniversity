defmodule FindYourFriendUniversity.Repo do
  use Ecto.Repo,
    otp_app: :find_your_friend_university,
    adapter: Ecto.Adapters.Postgres
end
