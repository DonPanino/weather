local currentWeather = "EXTRASUNNY"
local currentZone = nil
local transitioningWeather = false
local transitionStart = 0
local transitionEnd = 0
local transitionWeather = "fog"
local commandPermission = "weather.setzone"

-- Function to get the current weather based on the time and weather zones
local function getWeather(time, zone)
    local weather = Config.Weather.ZoneDefault -- Default weather for the zone
    for _, w in ipairs(Config.Weather) do
        if w.startTime <= time and w.endTime > time then
            weather = w.type
            break
        end
    end
    -- Add chance of rain, thunderstorm, or snow
    local chance = math.random(100)
    if chance <= Config.RainChance and weather ~= "RAIN" and zone.rain then
        weather = "RAIN"
    elseif chance <= Config.ThunderstormChance and weather ~= "THUNDER" and zone.thunderstorm then
        weather = "THUNDER"
    elseif chance <= Config.SnowChance and weather ~= "SNOW" and zone.snow then
        weather = "SNOW"
    end
    return weather
end

-- Function to set the weather for the current zone
local function setZoneWeather(zone, weather)
    TriggerClientEvent("qb-dynamicweather:changeWeather", -1, weather)
    currentWeather = weather
    currentZone = zone
    print("Dynamic Weather: Set zone '"..zone.name.."' weather to '"..weather.."'.")
end

-- Function to change the weather for the current zone
local function changeZoneWeather(zone, weather, transitionTime)
    if currentZone ~= zone then
        print("Dynamic Weather: Cannot change weather for inactive zone '"..zone.name.."'.")
        return
    end
    if transitioningWeather then
        print("Dynamic Weather: Weather is already transitioning.")
        return
    end
    if transitionTime == nil or transitionTime == 0 then
        setZoneWeather(zone, weather)
        return
    end
    transitioningWeather = true
    transitionStart = GetGameTimer()
    transitionEnd = transitionStart + transitionTime
    transitionWeather = weather
    print("Dynamic Weather: Starting weather transition in zone '"..zone.name.."' from '"..currentWeather.."' to '"..weather.."' over "..(transitionTime/1000).." seconds.")
end

-- Function to smoothly transition between weather states over a set period of time
local function updateTransitionWeather()
    if not transitioningWeather then
        return
    end
    local time = GetGameTimer()
    if time >= transitionEnd then
        setZoneWeather(currentZone, transitionWeather)
        transitioningWeather = false
        return
    end
    local progress = (time - transitionStart) / (transitionEnd - transitionStart)
    local current = currentZone.weather[currentWeather]
    local target = currentZone.weather[transitionWeather]
    local weather = {}
    weather.clouds = math.lerp(current.clouds, target.clouds, progress)
    weather.wind = math.lerp(current.wind, target.wind, progress)
    weather.windDir = math.lerp(current.windDir, target.windDir, progress)
    weather.fog = math.lerp(current.fog, target.fog, progress)
    TriggerClientEvent("qb-dynamicweather:updateWeather", -1, weather.clouds, weather.wind, weather.windDir, weather.fog)
end

-- Function to update the weather every minute based on the current time and zone
local function updateWeather()
local time = GetTime()
local zone = GetZone()

-- Check if the current zone has changed
if currentZone ~= zone then
    currentZone = zone
    currentWeather = getWeather(time, zone)
    setZoneWeather(zone, currentWeather)
    print("Dynamic Weather: Changed to zone '"..zone.name.."'.")
end

RegisterCommand('setweatherzone', function(source, args, rawCommand)
    print('setweatherzone command executed')
    local zone = args[1]
    local weather = args[2]
    local duration = tonumber(args[3])
    if zone and weather and duration then
        for _, zoneData in ipairs(Config.WeatherZones) do
            if zoneData.name == zone then
                TriggerClientEvent('weatherZone:changeWeather', -1, zone, weather, duration)
                print(('Changed weather for zone "%s" to "%s" for %d seconds.'):format(zone, weather, duration))
                break
            end
        end
    else
        TriggerClientEvent('QBCore:Notify', '/setweatherzone [zone] [weather] [duration]')
    end
    print('setweatherzone command finished')
end)




-- Check if the weather needs to be changed based on the time and chance
if not transitioningWeather and time >= nextWeatherChange then
    local weather = getWeather(time, currentZone)
    if weather ~= currentWeather then
        changeZoneWeather(currentZone, weather, Config.TransitionTime)
        nextWeatherChange = time + Config.WeatherChangeInterval
    end
end

updateTransitionWeather()

end