defmodule Weather do
end

defmodule Weather.CurrentWeather do
  @derive [Poison.Encoder]
  defstruct [:weather, :main, :wind, :name]
end

defmodule Weather.Location do
  @derive [Poison.Encoder]

  defstruct [:country_name, :country_code, :region_code, :region_name,
             :city, :zip_code]
end
