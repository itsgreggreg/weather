defmodule Weather.GoogleGeocode do

  @api_key "AIzaSyDhgLThtDN-EsmonqeVjbUojjjsPasaOu8"
  @geocode_endpoint "https://maps.googleapis.com/maps/api/geocode/json?key=#{@api_key}"

  def geocode_location(input) do
    case HTTPoison.get(url(input)) do
      {:ok, %{body: body}} ->
        locationize Poison.Parser.parse(body)
      _ -> {:error, "Couldn't determine your location"}
    end
  end

  defp url(address) do
    String.replace("#{@geocode_endpoint}&address=#{address}", " ", "%20")
  end

  defp locationize({:ok, gloc = %{"status" => "OK"}}) do
    gloc = hd gloc["results"]
    {:ok, %Weather.Location{
      latitude: gloc["geometry"]["location"]["lat"],
      longitude: gloc["geometry"]["location"]["lng"],
      city: gloc["formatted_address"]
    }}
  end
  defp locationize(body), do: IO.puts(inspect body);{:error, "Couldn't decipher that location."}
end
