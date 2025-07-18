alias FindYourFriendUniversity.Districts
alias FindYourFriendUniversity.Counties
alias FindYourFriendUniversity.Parishes
alias FindYourFriendUniversity.Locations
import FindYourFriendUniversity.Helpers

defmodule FindYourFriendUniversity.LocationsSeeds do
  def parse_locations_json_seeds(json) do
    json
    |> Enum.each(fn {year, locations_data} ->
      IO.puts("\n--- Processing year #{year} ---")
      parse_locations_aux(locations_data, year)
    end)
  end

  defp parse_locations_aux(json, year) do
    districts =
      json
      |> Enum.map(fn district ->
        %{
          name: district["name"],
          id: district["district_code"],
          counties: district["counties"]
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
      districts
      |> Enum.flat_map(fn district ->
        district.counties
        |> Enum.map(fn county ->
          %{
            name: county["name"],
            id: county["county_code"],
            district_id: district.id,
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
      counties
      |> Enum.flat_map(fn county ->
        county.parishes
        |> Enum.map(fn parish ->
          %{
            name: parish["name"],
            id: parish["parish_code"],
            county_id: county.id,
            people: parish["people"] || []
          }
        end)
      end)

    case Parishes.create_multiple_parishes(parishes) do
      {:ok, {created_parishes, []}} ->
        IO.puts("Stored #{created_parishes}/#{length(parishes)} Parishes from seeds ond DB.")

      {:error, errors} ->
        IO.inspect(errors, label: "Parishes inserting errors: ")
        raise "Parishes inserting error. See errors below."
    end

    locations =
      parishes
      |> Enum.flat_map(fn parish ->
        parish.people
        |> Enum.map(fn person ->
          %{
            name:
              person["name"]
              |> String.trim()
              |> normalize_string([32])
              |> String.replace(~r/\s+/, " ")
              |> String.replace(" *** ", " "),
            civil_id: person["civil_id"] |> String.trim() |> String.replace("*", "x"),
            parish_id: parish.id,
            year: year
          }
        end)
        |> Enum.filter(fn person -> person.civil_id != "" end)
      end)

    case Locations.create_multiple_locations(locations) do
      {:ok, {created_locations, []}} ->
        IO.puts("Stored #{created_locations}/#{length(locations)} Locations from seeds ond DB.")

      {:error, errors} ->
        IO.inspect(errors, label: "Locations inserting errors: ")
        raise "Locations inserting error. See errors below."
    end
  end
end
