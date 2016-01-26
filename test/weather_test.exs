defmodule WeatherTest do
  use ExUnit.Case
  doctest Weather

  import Weather.LocationParser,  only: [parse_location: 1]

  test "Can parse locations" do
    assert parse_location("90210") ==
           %Weather.Location{zip_code: 90210, country_code: "US"}

    assert parse_location("chicago") ==
           %Weather.Location{city: "chicago", country_code: "US"}

    assert parse_location("berlin germany") ==
           %Weather.Location{city: "berlin", country_name: "germany"}

    assert parse_location("berlin de") ==
           %Weather.Location{city: "berlin", country_code: "de"}

    assert parse_location("san juan, costa rica") ==
           %Weather.Location{city: "san juan", country_name: "costa rica"}
  end
end
