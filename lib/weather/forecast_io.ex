defmodule Weather.ForecastIo do
  @api_key "49739801ad656493976ef83a2a816cff"
  @url "https://api.forecast.io/forecast/#{@api_key}/"

  def get_current_weather(location) do
    case HTTPoison.get(api_url(location)) do
      {:ok, %{body: body}} ->
        Poison.Parser.parse(body)
      _ -> {:error, "Couldn't retrieve the weather."}
    end
  end

  def api_url(%Weather.Location{latitude: lat, longitude: lon}) when
             not is_nil(lat) and not is_nil(lon) do
    "#{@url}#{lat},#{lon}"
  end

  def api_url(_), do: {:error, "Latitude and Longitude could not be determined"}
end
