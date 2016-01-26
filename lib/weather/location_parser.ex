defmodule Weather.LocationParser do
  @moduledoc """
  Utility class for parsing user input into a searchable location.
  """

  @doc """
  If there is a zip code, the rest of the input is treated as the country.
  Country can either be a 2 char short code, or the full country name.
  If there is no country, US is used.
  If there is no zip code, there must be a city and a country.
  The last word is treated as the country
  If there is only 1 word, it is treated as the city and US is used for the country.
  To use a country name that is more than one word, place a comma between the city and contry.
  """

  def parse_location(input) do
    {zip, rest} = parse_zip(input)
    strings = String.split(rest, ",") |> Enum.map(&(String.strip(&1)))
    {zip, city, country} = case {zip, strings} do
      {nil, [city]} ->
        case String.split(city," ") do
          [city] ->
            {nil, city, "US"}
          parts ->
            city = List.delete_at(parts, -1) |> Enum.join(" ")
            country = List.last(parts)
            {nil, city, country}
        end
      {nil, [city, country]} -> {nil, city, country}
      {zip, [""]} -> {zip, nil, "US"}
      {zip, [country]} -> {zip, nil, country}
    end

    cond do
      String.length(country) > 2 -> %Weather.Location{
        zip_code: zip, country_name: country, city: city}

      true -> %Weather.Location{
        zip_code: zip, country_code: country, city: city}
    end

  end

  defp parse_zip(bin) do
    case Integer.parse(bin) do
      {int, rest} -> {"#{int}", String.strip(rest)}
      :error -> {nil, bin}
    end
  end
end
