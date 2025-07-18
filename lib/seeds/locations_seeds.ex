alias FindYourFriendUniversity.Districts
alias FindYourFriendUniversity.Counties
alias FindYourFriendUniversity.Parishes
alias FindYourFriendUniversity.Students

defmodule FindYourFriendUniversity.LocationsSeeds do
  def parse_locations_json_seeds(json) do
    districts =
      json
      |> Enum.map(fn district ->
        %{
          name: district["name"],
          id: district["district_code"]
        }
      end)

    case Districts.create_multiple_districts(districts) do
      {:ok, {created_districts, []}} ->
        IO.puts("Stored #{created_districts}/#{length(districts)} Districts from seeds ond DB.")

      {:error, errors} ->
        IO.inspect(errors, label: "Districts inserting errors: ")
        raise "Districts inserting error. See errors below."
    end

    counties =
      json
      |> Enum.flat_map(fn district ->
        district["counties"]
        |> Enum.map(fn county ->
          %{
            name: county["name"],
            id: county["county_code"],
            district_id: district["district_code"],
            parishes: county["parishes"]
          }
        end)
      end)

    case Counties.create_multiple_counties(counties) do
      {:ok, {created_counties, []}} ->
        IO.puts("Stored #{created_counties}/#{length(counties)} Counties from seeds ond DB.")

      {:error, errors} ->
        IO.inspect(errors, label: "Counties inserting errors: ")
        raise "Counties inserting error. See errors below."
    end

    parishes =
      json
      |> Enum.flat_map(fn district ->
        district["counties"]
        |> Enum.flat_map(fn county ->
          county["parishes"]
          |> Enum.map(fn parish ->
            %{
              name: parish["name"],
              id: parish["parish_code"],
              county_id: county["county_code"]
            }
          end)
        end)
      end)

    case Parishes.create_multiple_parishes(parishes) do
      {:ok, {created_parishes, []}} ->
        IO.puts("Stored #{created_parishes}/#{length(parishes)} Parishes from seeds ond DB.")

      {:error, errors} ->
        IO.inspect(errors, label: "Parishes inserting errors: ")
        raise "Parishes inserting error. See errors below."
    end
  end
end
