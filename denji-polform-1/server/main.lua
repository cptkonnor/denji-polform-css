local QBCore = exports['qb-core']:GetCoreObject()
local webhook = GetConvar('police_app_webhook', 'not_set')
local playersInZone = {}

if webhook == 'not_set' or webhook == '' then
    print("[ERROR] Police Application: Discord webhook is not configured!")
end

RegisterNetEvent('police:playerEnteredZone', function()
    playersInZone[source] = os.time() + 60
end)

RegisterNetEvent('police:submitApplication', function(data)
    local src = source
    local user = QBCore.Functions.GetPlayer(src)

    if not playersInZone[src] or os.time() > playersInZone[src] then
        TriggerClientEvent('police:applicationResult', src, false, Config.Locale.failure_not_in_zone)
        return
    end
    
    playersInZone[src] = nil
    if not user then return end

    local embed = {
        {
            title = Config.Locale.discord_embed_title,
            color = 3447003,
            fields = {},
            footer = {
                text = string.format(Config.Locale.discord_embed_footer, user.PlayerData.charinfo.firstname, user.PlayerData.charinfo.lastname, user.PlayerData.citizenid),
            },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%S.000Z"),
        }
    }

    for i, question in ipairs(Config.Questions) do
        local answer = data['question-' .. (i - 1)] or "N/A"
        table.insert(embed[1].fields, {
            name = question.label,
            value = "```\n" .. tostring(answer) .. "\n```",
            inline = false
        })
    end
    
    PerformHttpRequest(webhook, function(err, text, headers)
        if err == 204 or err == 200 then
            TriggerClientEvent('police:applicationResult', src, true)
        else
            print("Error submitting police application. HTTP error: " .. err)
            TriggerClientEvent('police:applicationResult', src, false)
        end
    end, 'POST', json.encode({ embeds = embed }), { ['Content-Type'] = 'application/json' })
end)

AddEventHandler('playerDropped', function()
    playersInZone[source] = nil
end)