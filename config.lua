Config = {
    dynamicTransitions = true,
    timeOfDayEffects = true,
    chanceOfRain = 25,
    chanceOfThunderstorm = 5,
    chanceOfSnow = 10,
    WeatherZones = {
        {name = "Ls", center = vector3(267.92, -1361.83, 24.53), radius = 3000, rain = true, thunderstorm = true, snow = false},
        {name = "Blaine", center = vector3(-440.5, 6011.0, 31.72), radius = 3000, rain = true, thunderstorm = true, snow = true},
        {name = "Chiliad", center = vector3(501.24, 5603.99, 797.91), radius = 500, rain = true, thunderstorm = true, snow = true},
    },
    weatherTypes = {
        "EXTRASUNNY",
        "CLEAR",
        "NEUTRAL",
        "SMOG",
        "FOGGY",
        "OVERCAST",
        "CLOUDS",
        "CLEARING",
        "RAIN",
        "THUNDER",
        "SNOW",
        "BLIZZARD",
        "SNOWLIGHT",
        "XMAS",
        "HALLOWEEN",
    },
    RainChance = 20, -- Chance of rain (percentage)
    ThunderstormChance = 5, -- Chance of thunderstorm (percentage)
    SnowChance = 10, -- Chance of snow (percentage)
}
