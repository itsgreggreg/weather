# Weather
A little command line utitlity for getting the current weather written in Elixir

## Installation
 - Gotta have the Elixir platform installed: http://elixir-lang.org/install.html
 - `curl -o /usr/local/bin/weather https://raw.githubusercontent.com/itsgreggreg/weather/escript/weather`
 - `chmod +x /usr/local/bin/weather`
 - Make sure wherever you downloaded weather to is in your path

## Usage
Call `weather` from the command line.
```bash
> weather
Current Weather in New Orleans is: 46°F, Mostly cloudy
  Time: 11  12  13  14  15  16  17  18  19  20  21  22
  Temp: 45  46  47  49  50  52  53  52  52  50  49  48°F
Precip:  2   0   6   3   2   1   1   1   2   5  13  17%
 Humid: 88  84  82  80  78  78  77  77  76  75  74  74%
```
You can specify a location:
```bash
> weather paris, france
Current Weather in Paris, France is: 54°F, Breezy and overcast
  Time: 11  12  13  14  15  16  17  18  19  20  21  22
  Temp: 54  54  53  53  52  52  52  51  50  49  48  48°F
Precip: 23  31  29  23  24  40  53  56  60  62  63  61%
 Humid: 83  82  83  84  85  86  88  89  91  92  92  92%
```

### Options
 - -s | --short : Get a short weather status
```bash
> ./weather tokyo -s
Current Weather in Tokyo, Japan is: 36°F, Clear
```

 - -c | --celcius : all temperatures in celcius
```bash
> weather berlin, germany -c
Current Weather in Berlin, Germany is: 9°C, Overcast
  Time: 11  12  13  14  15  16  17  18  19  20  21  22
  Temp:  9   9   9   9   8   8   7   7   7   7   7   8°C
Precip:  1   1   0   0   0   0   2   6   9  14  23  45%
 Humid: 74  84  85  86  87  89  91  92  92  92  91  92%
```

- options can be combined
```bash
> weather prague -cs
Current Weather in Prague, Czech Republic is: 8°C, Mostly cloudy
```
