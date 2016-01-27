defmodule Weather.Formatter do

  def puts(weather, location, switches) do
    IO.puts("""
      Current Weather in #{location.city} \
      #{temp(weather["currently"]["temperature"], switches, true)} and \
      #{String.capitalize weather["currently"]["summary"]}\
      """)

    unless Keyword.get(switches, :short) do
      hourly_data = weather["hourly"]["data"]
      |> Enum.take(12)

      times = pluck(hourly_data, "time")
      |> Enum.map(&hour_from_unix(&1))
      |> space_and_join(3, " ")
      IO.puts "  Time: #{times}"

      unit = if {:celcius, true} in switches, do: "C", else: "F"
      temps = pluck(hourly_data, "temperature")
      |> Enum.map(&round(&1))
      |> Enum.map(&temp(&1, switches))
      |> space_and_join(3, " ")
      IO.puts "  Temp: #{temps}°#{unit}"

      precips = pluck(hourly_data, "precipProbability")
      |> Enum.map(&(round(&1*100)))
      |> space_and_join(3, " ")
      IO.puts "Precip: #{precips}%"

      humids = pluck(hourly_data, "humidity")
      |> Enum.map(&round(&1*100))
      |> space_and_join(3, " ")
      IO.puts " Humid: #{humids}%"
    end

    :ok
  end

  defp hour_from_unix(timestamp) do
    {:ok, time} = Calendar.DateTime.Parse.unix!(timestamp)
    |> Calendar.DateTime.shift_zone(Timex.Date.local.timezone.full_name)
    "#{time.hour} "
  end

  defp pluck(list, key) do
    for item <- list, do: item[key]
  end

  defp space_and_join(list, spaces, sep) do
    Enum.map(list, &String.ljust("#{&1}", spaces))
    |> Enum.join(sep)
  end

  defp temp(num, switches, false), do: temp(num, switches)
  defp temp(num, switches, true) do
    unit = (case {:celcius, true} in switches do
      true  -> "°C"
      false -> "°F"
    end)
    "#{temp(num, switches)}#{unit}"
  end

  defp temp(num, switches) do
    if {:celcius, true} in switches do
      num = (num - 32) / 9 * 5
    end
    round(num)
  end

end