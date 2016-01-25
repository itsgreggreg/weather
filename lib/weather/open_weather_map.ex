defmodule Weather.OpenWeatherMap do
  @api_key "cbd1832d18eb7f6334d4a8aefb171c08"
  @url "http://api.openweathermap.org/data/2.5/weather?zip="

  def get_current_weather_by_zip(zip) do
    case HTTPoison.get(api_url(zip)) do
      {:ok, %{body: body}} ->
        Poison.decode(body, as: %Weather.CurrentWeather{})
      _ -> {:error, "Couldn't retrieve the weather for #{zip}"}
    end
  end

  defp api_url(zip) do
    @url <> zip <> "&appid=" <> @api_key
  end
end
