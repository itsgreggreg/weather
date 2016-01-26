defmodule Weather.OpenWeatherMap do
  @api_key "cbd1832d18eb7f6334d4a8aefb171c08"
  @url "http://api.openweathermap.org/data/2.5/weather?"

  def get_current_weather(location) do
    case HTTPoison.get(api_url(location)) do
      {:ok, %{body: body}} ->
        # IO.puts(inspect body)
        Poison.decode(body, as: %Weather.CurrentWeather{})
      _ -> {:error, "Couldn't retrieve the weather."}
    end
  end

  def api_url(location = %{zip_code: nil}) do
    country = location.country_code || location.country_name
    url = @url <> "q=" <> location.city <> "," <> country <> "&appid=" <> @api_key
  end

  def api_url(location) do
    country = location.country_code || location.country_name
    url = @url <> "zip=" <> location.zip_code <> "," <> country <> "&appid=" <> @api_key
  end
end
