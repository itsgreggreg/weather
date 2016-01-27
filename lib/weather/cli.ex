defmodule Weather.CLI do
  import Weather.LocationParser,  only: [parse_location: 1]

  @switches [short: :boolean]
  @switch_aliases [s: :short]

  def main(argv) do
    weather_data = ProgressBar.render_spinner([frames: :braille, done: :remove], fn ->
      argv
      |> parse_args
      |> process
    end)
    case weather_data do
      {weather, location, switches} ->
        Weather.Formatter.puts(weather, location, switches)
      {:error, reason} -> IO.puts "OOPS.. #{reason}"
    end
  end

  def parse_args(argv) do
    args = OptionParser.parse(argv, switches: @switches, aliases: @switch_aliases)
    case args do
      {switches,[],[]} -> {:no_location, switches}
      {switches,location,[]} ->
        {Enum.join(location, " ") |> parse_location, switches}
    end
  end

  def process({:no_location, switches}) do
    case Weather.UserLocator.locate_user do
      {:ok, location = %Weather.Location{}} -> process(location, switches)
      error -> error
    end
  end

  def process(location, switches) do
    case Weather.ForecastIo.get_current_weather(location) do
      {:ok, current_weather} -> {current_weather, location, switches}
      error -> error
    end
  end
end
