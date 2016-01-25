defmodule Weather.CurrentWeather do
  @derive [Poison.Encoder]
  defstruct [:weather, :main, :wind, :name]
end
