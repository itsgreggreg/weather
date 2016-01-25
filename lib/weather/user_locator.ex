defmodule Weather.UserLocator do
  # @my_ip_url Application.get_env(:weather, :my_ip_url)
  @my_ip_url "http://bot.whatismyipaddress.com/"
  @location_from_ip_url "http://freegeoip.net/json/"

  def locate_user do
    get_ip
    |> get_location_from_ip
  end

  def get_ip do
    case HTTPoison.get(@my_ip_url) do
      {:ok, %{body: ip}} -> ip
      _ -> {:error, "Couldn't determine your IP Address"}
    end
  end

  def get_location_from_ip(ip) do
    case HTTPoison.get(@location_from_ip_url <> ip) do
      {:ok, %{body: body}} ->
        Poison.decode(body, as: %Weather.Location{})
      _ -> {:error, "Couldn't determine your location"}
    end
  end

  def get_location_from_ip(e), do: e
end
