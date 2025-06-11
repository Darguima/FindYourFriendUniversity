alias FindYourFriendUniversity.DGESSeeds

~S"""
This script will load all the files at ./seeds/ folder that match the expected naming pattern and use them to seed the DB.

## File Naming

In order to the script know what is loading, the files inside ./seeds/ need to follow a correct naming.

  - DGES applications files -> applications_*.json

## Running

Since this is the default Ecto seeding script

> mix ecto.setup

"""

seeds_folder = "./seeds"

case File.ls(seeds_folder) do
  {:error, reason} ->
    IO.puts("Failed to list files. Reason: #{reason}.")

  {:ok, files} ->
    Enum.each(files, fn file_name ->
      [type | _] = String.split(file_name, "_")
      file_path = Path.join([seeds_folder, file_name])

      IO.puts("\nParsing file #{file_name}.")

      case File.read(file_path) do
        {:error, reason} ->
          IO.puts("Failed to read file. Reason: #{reason}.")

        {:ok, file_content} ->
          case Jason.decode(file_content) do
            {:error, _} ->
              IO.puts("Not a valid JSON file.")

            {:ok, json_data} ->
              case type do
                "applications" ->
                  DGESSeeds.parse_dges_json_seeds(json_data)
                  IO.puts("Seeded successfully.")

                _ ->
                  IO.puts("Ignored file. Reason: no name pattern match.")
              end
          end
      end
    end)
end
