defmodule Weather.CLI do
  # import Weather.LocationParser,  only: [parse_location: 1]
  import Weather.GoogleGeocode, only: [geocode_location: 1]

  @switches [short: :boolean, celcius: :boolean, help: :boolean, version: :boolean]
  @switch_aliases [s: :short, c: :celcius, h: :help, v: :version]
  @project Weather.Mixfile.project()

  def main(argv) do
    weather_data = ProgressBar.render_spinner(spinner_options, fn ->
      argv
      |> parse_args
      |> process
    end)
    case weather_data do
      <<msg::binary>> -> IO.puts msg
      {weather, location, switches} ->
        Weather.Formatter.puts(weather, location, switches)
      {:error, reason} -> IO.puts "OOPS.. #{reason}"
    end
  end

  def parse_args(argv) do
    args = OptionParser.parse(argv, switches: @switches, aliases: @switch_aliases)
    |> parse_unknown_args
    case args do
      {[help: true], _, _} -> :help
      {[version: true], _, _} -> :version
      {switches,[],[]} -> {:no_location, switches}
      {switches,location,[]} ->
        {:geocode_location, Enum.join(location, " "), switches}
    end
  end

  def parse_unknown_args({a,b,[]}), do: {a,b,[]}
  def parse_unknown_args({switches,b,[{switch,_}|_]}) do
    letters = tl(String.split(switch, ""))
    switches = List.foldl(letters, switches, fn(letter, acc) ->
      if alias = Keyword.get(@switch_aliases, String.to_atom(letter)) do
        [{alias, true}|acc]
      else
        acc
      end
    end)
    {switches, b, []}
  end

  def process({:no_location, switches}) do
    case Weather.UserLocator.locate_user do
      {:ok, location = %Weather.Location{}} -> process(location, switches)
      error -> error
    end
  end

  def process({:geocode_location, location, switches}) do
    case geocode_location(location) do
      {:ok, loc = %Weather.Location{}} -> process(loc, switches)
      error -> error
    end
  end

  def process(location, switches) do
    case Weather.ForecastIo.get_current_weather(location) do
      {:ok, current_weather} -> {current_weather, location, switches}
      error -> error
    end
  end

  def process(:help) do
    """
    A little command line utility for checking the weather.
    Options:
      --celcius, -c : Get all temperatures in celcius
      --short  , -s : Get just the current weather
      --version, -v : Version of this application
      --help   , -h : This help message
    """
  end

  def process(:version) do
    "weather #{@project[:version]}"
  end

  defp spinner_options do
    text = Enum.random [
      "Asking around...",
      "Stepping outside...",
      "Calling friends...",
      "Why are you asking me? JK, I'll check..",
      "Computig weathers...",
      "Looking it up and stuff...",
      "Checking with a friend who knows..."
    ]
    [frames: :braille, text: text,done: :remove]
  end
end
