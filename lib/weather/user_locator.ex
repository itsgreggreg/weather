defmodule Weather.UserLocator do
  @location_endpoint "http://freegeoip.net/json/"

  def locate_user do
    case HTTPoison.get(@location_endpoint) do
      {:ok, %{body: body}} ->
        Poison.decode(body, as: %Weather.Location{})
      _ -> {:error, "Couldn't determine your location"}
    end
  end
end
