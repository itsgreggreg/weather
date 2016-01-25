defmodule Weather.CLI do

  def main(argv) do
    argv
    |> parse_args
    |> process
  end

  def parse_args(argv) do
    args = OptionParser.parse(argv)
    case args do
      {[],[],[]} -> :no_location
      {[],[zip],[]} -> {:zip_code, zip}
    end
  end

  def process(:no_location) do
    IO.puts "Determining location..."
    case Weather.UserLocator.locate_user do
      {:ok, location = %Weather.Location{}} -> process({:zip_code, location.zip_code})
      {:error, reason} -> IO.puts "OOPS! #{inspect reason}"
    end
  end

  def process({:zip_code, zip}) when is_integer(zip) do
    process {:zip_code, "#{zip}"}
  end

  def process({:zip_code, zip}) do
    IO.puts "Current Weather for #{zip}"
    case Weather.OpenWeatherMap.get_current_weather_by_zip(zip) do
      {:ok, current_weather = %Weather.CurrentWeather{}} ->
        format_current_weather(current_weather)
      {:error, reason} -> IO.puts "OOPS! #{inspect reason}"
    end
  end

  def format_current_weather(weather = %Weather.CurrentWeather{}) do
    IO.puts("#{k_to_f weather.main["temp"]}°F and #{String.capitalize hd(weather.weather)["description"]}")
  end

  defp k_to_f(k), do: round (k - 273.15) * 1.8000 + 32.00
end
