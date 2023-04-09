local display = true
local displayTimer = false
local displayZone = ""
local displayWeather = ""
local displayDuration = 0
local displayX = 0.5 -- X position of the display
local displayY = 0.05 -- Y position of the display

function DrawText(text, x, y)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextScale(0.0, 0.4)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if display then
            DrawText("Zone: "..displayZone.." | Weather: "..displayWeather.." | Duration: "..displayDuration, displayX, displayY)
        end

        if IsControlJustPressed(1, 166) then -- Toggle display with the F5 key
            display = not display
            if not display then
                displayTimer = false
            end
        end
    end
end)

RegisterNetEvent('weatherZone:displayWeather')
AddEventHandler('weatherZone:displayWeather', function(zone, weather, duration)
    if display then
        displayZone = zone
        displayWeather = weather
        displayDuration = duration
        displayTimer = GetGameTimer() + (duration * 1000)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if displayTimer then
            if GetGameTimer() > displayTimer then
                displayTimer = false
            end
        end
    end
end)
