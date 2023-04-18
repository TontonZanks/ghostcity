ESX, players, items = nil, {}, {}
inService = {}

warnedPlayers = {}
blacklistedLicenses = {}

MySQL.ready(function()
    MySQL.Async.fetchAll("SELECT * FROM items", {}, function(result)
        for k, v in pairs(result) do
            items[k] = { label = v.label, name = v.name }
        end
    end)
end)

local function getLicense(source)
    if (source ~= nil) then
        local identifiers = {}
        local playerIdentifiers = GetPlayerIdentifiers(source)
        for _, v in pairs(playerIdentifiers) do
            local before, after = playerIdentifiers[_]:match("([^:]+):([^:]+)")
            identifiers[before] = playerIdentifiers
        end
        return identifiers
    end
end

local function isStaff(source)
    return players[source].rank ~= "user"
end

local function isWebhookSet(val)
    return val ~= nil and val ~= ""
end

TriggerEvent('esx:getShaldoxaredObjaldoxect', function(obj)
    ESX = obj
end)

RegisterServerEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(source, xPlayer)
    local source = source
    if players[source] then
        return
    end
    TriggerClientEvent("adminmenu:cbPermLevel", source, xPlayer.getGroup())
    print(("^1[Admin Menu] ^7Player ^3%s ^7loaded with group ^1%s^7 ! ^7"):format(GetPlayerName(source),xPlayer.getGroup()))
    players[source] = {
        timePlayed = { 0, 0 },
        rank = xPlayer.getGroup(),
        name = GetPlayerName(source),
        license = getLicense(source)["license"],
    }
    if players[source].rank ~= "user" then
        TriggerClientEvent("adminmenu:cbItemsList", source, items)
        TriggerClientEvent("adminmenu:cbReportTable", source, reportsTable)
        TriggerClientEvent("adminmenu:updatePlayers", source, players)
    end
end)

AddEventHandler("playerDropped", function(reason)
    local source = source
    players[source] = nil
    reportsTable[source] = nil
    updateReportsForStaff()
end)

RegisterNetEvent("adminmenu:setStaffState")
AddEventHandler("adminmenu:setStaffState", function(newVal, sneaky)
    local source = source
    TriggerClientEvent("adminmenu:cbStaffState", source, newVal)
    local byState = {
        [true] = "~r~[Staff] ~y~%s ~s~est désormais ~g~actif ~s~en staffmode.",
        [false] = "~r~[Staff] ~y~%s ~s~a ~r~désactivé ~s~son staffmode."
    }
    if newVal then
        inService[source] = true
    else
        inService[source] = nil
    end
    if not sneaky then
        for k,player in pairs(players) do
            if player.rank ~= "user" and inService[k] ~= nil then
                TriggerClientEvent("esx:showNotification", k, byState[newVal]:format(GetPlayerName(source)))
            end
        end
    end
end)

RegisterNetEvent("adminmenu:goto")
AddEventHandler("adminmenu:goto", function(target)
    local source = source
    local rank = players[source].rank
    if not canUse("teleport", rank) then
        DropPlayer(source, "Permission invalide")
        return
    end
    local coords = GetEntityCoords(GetPlayerPed(target))
    TriggerClientEvent("adminmenu:setCoords", source, coords)
    if isWebhookSet(Config.webhook.onTeleport) then
        sendWebhook(("L'utilisateur %s s'est téléporté sur %s"):format(GetPlayerName(source), GetPlayerName(target)), "grey", Config.webhook.onItemGive)
    end
end)

RegisterNetEvent("adminmenu:bring")
AddEventHandler("adminmenu:bring", function(target, coords)
    local source = source
    local rank = players[source].rank
    if not canUse("teleport", rank) then
        DropPlayer(source, "Permission invalide")
        return
    end
    TriggerClientEvent("adminmenu:setCoords", target, coords)
    if isWebhookSet(Config.webhook.onTeleport) then
        sendWebhook(("L'utilisateur %s a téléporté %s sur lui"):format(GetPlayerName(source), GetPlayerName(target)), "grey", Config.webhook.onItemGive)
    end
end)

RegisterNetEvent("adminmenu:tppc")
AddEventHandler("adminmenu:tppc", function(target, coords)
    local source = source
    local rank = players[source].rank
    if not canUse("tppc", rank) then
        DropPlayer(source, "Permission invalide")
        return
    end
    TriggerClientEvent("adminmenu:setCoords", target, vector3(-280.633, -931.717, 31.25))
    TriggerClientEvent("esx:showNotification", source, "~g~Téléportation effectuée")
end)

RegisterNetEvent("adminmenu:tphopi")
AddEventHandler("adminmenu:tphopi", function(target, coords)
    local source = source
    local rank = players[source].rank
    if not canUse("tppc", rank) then
        DropPlayer(source, "Permission invalide")
        return
    end
    TriggerClientEvent("adminmenu:setCoords", target, vector3(312.429, -580.982, 43.284))
    TriggerClientEvent("esx:showNotification", source, "~g~Téléportation effectuée")
end)

RegisterNetEvent("adminmenu:tppdp")
AddEventHandler("adminmenu:tppdp", function(target, coords)
    local source = source
    local rank = players[source].rank
    if not canUse("tppc", rank) then
        DropPlayer(source, "Permission invalide")
        return
    end
    TriggerClientEvent("adminmenu:setCoords", target, vector3(427.825, -981.989, 30.75))
    TriggerClientEvent("esx:showNotification", source, "~g~Téléportation effectuée")
end)

RegisterNetEvent("adminmenu:give")
AddEventHandler("adminmenu:give", function(target, itemName, qty)
    local source = source
    local rank = players[source].rank
    if not canUse("give", rank) then
        DropPlayer(source, "Permission invalide")
        return
    end
    local xPlayer = ESX.GetPlayerFromId(tonumber(target))
    if xPlayer then
        xPlayer.addInventoryItem(itemName, tonumber(qty))
        TriggerClientEvent("esx:showNotification", source, ("~g~Give de %sx%s au joueur %s effectué"):format(qty, itemName, GetPlayerName(target)))
        if isWebhookSet(Config.webhook.onItemGive) then
            sendWebhook(("L'utilisateur %s a give %sx%s a %s"):format(GetPlayerName(source), qty, itemName, GetPlayerName(target)), "grey", Config.webhook.onItemGive)
        end
    else
        TriggerClientEvent("esx:showNotification", source, "~r~Ce joueur n'est plus connecté")
    end
end)

RegisterNetEvent("adminmenu:message")
AddEventHandler("adminmenu:message", function(target, message)
    local source = source
    local rank = players[source].rank
    if not canUse("mess", rank) then
        DropPlayer(source, "Permission invalide")
        return
    end
    TriggerClientEvent("esx:showNotification", source, ("~g~Message envoyé à %s"):format(GetPlayerName(target)))
    TriggerClientEvent("esx:showNotification", target, ("~r~Message du staff~s~: %s"):format(message))
    if isWebhookSet(Config.webhook.onMessage) then
        sendWebhook(("L'utilisateur %s a envoyé un message à %s:\n\n__%s__"):format(GetPlayerName(source), GetPlayerName(target), message), "grey", Config.webhook.onMessage)
    end
end)

RegisterNetEvent("adminmenu:kick")
AddEventHandler("adminmenu:kick", function(target, message)
    local source = source
    local rank = players[source].rank
    if not canUse("kick", rank) then
        DropPlayer(source, "Permission invalide")
        return
    end
    TriggerClientEvent("esx:showNotification", source, ("~g~Expulsion de %s effectuée"):format(GetPlayerName(target)))
    local name = GetPlayerName(target)
    DropPlayer(target, ("[Admin] Expulsé: %s"):format(message))
    if isWebhookSet(Config.webhook.onKick) then
        sendWebhook(("L'utilisateur %s a expulsé %s pour la raison:\n\n__%s__"):format(GetPlayerName(source), name, message), "grey", Config.webhook.onKick)
    end
end)

RegisterNetEvent("adminmenu:revive")
AddEventHandler("adminmenu:revive", function(target)
    local source = source
    local rank = players[source].rank
    if not canUse("revive", rank) then
        DropPlayer(source, "Permission invalide")
        return
    end
    TriggerClientEvent("esx:showNotification", source, ("~g~Revive de %s effectué"):format(GetPlayerName(target)))
    TriggerClientEvent("esx_ambulancejob:realdoxvive", target)
    local name = GetPlayerName(target)
    if isWebhookSet(Config.webhook.onRevive) then
        sendWebhook(("L'utilisateur %s a revive %s"):format(GetPlayerName(source), name), "grey", Config.webhook.onRevive)
    end
end)

RegisterNetEvent("adminmenu:heal")
AddEventHandler("adminmenu:heal", function(target)
    local source = source
    local rank = players[source].rank
    if not canUse("heal", rank) then
        DropPlayer(source, "Permission invalide")
        return
    end
    TriggerClientEvent("esx:showNotification", source, ("~g~Heal de %s effectué"):format(GetPlayerName(target)))
    TriggerClientEvent('esx_status:healPlayer', target)
    local name = GetPlayerName(target)
    if isWebhookSet(Config.webhook.onHeal) then
        sendWebhook(("L'utilisateur %s a heal %s"):format(GetPlayerName(source), name), "grey", Config.webhook.onHeal)
    end
end)

RegisterNetEvent("adminmenu:warn")
AddEventHandler("adminmenu:warn", function(target, reason)
    local source = source
    local rank = players[source].rank
    if not canUse("warn", rank) then
        DropPlayer(source, "Permission invalide")
        return
    end
    local license = getLicense(target)
    if warnedPlayers[license] == nil then
        warnedPlayers[license] = 0
    end
    warnedPlayers[license] = (warnedPlayers[license] + 1)
    TriggerClientEvent("esx:showNotification", source, ("~g~Warn envoyé à %s"):format(GetPlayerName(target)))
    TriggerClientEvent("esx:showNotification", target, ("~r~Vous avez reçu un avertissement~s~: %s"):format(reason))
    TriggerClientEvent("adminmenu:receivewarn", target, reason)
    print(json.encode(warnedPlayers[license]))
    if warnedPlayers[license] > 2 then
        DropPlayer(target, "3 Avertissements atteints ! Vous pourrez vous reconnecter au prochain reboot.")
    end
    print(warnedPlayers[license])
end)

AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
    local _src = source
    deferrals.defer()
    deferrals.update("Vérification des warn...")
    Wait(2500)
    local license = getLicense(_src)
    if warnedPlayers[license] and warnedPlayers[license] > 2 then
        deferrals.done("Vous avez 3 avertissements actif, vous ne pouvez donc pas vous connecter avant le prochain reboot")
    else
        deferrals.done()
    end
end)

RegisterNetEvent("adminmenu:wipe")
AddEventHandler("adminmenu:wipe", function(target)
    local source = source
    local rank = players[source].rank
    if not canUse("wipe", rank) then
        DropPlayer(source, "Permission invalide")
        return
    end
    local xPlayer = ESX.GetPlayerFromId(target)
    local name = GetPlayerName(target)
    if xPlayer then
        DropPlayer(target, "Wipe en cours...")
        local TimerWipe = 100
        MySQL.Sync.execute("DELETE FROM users WHERE identifier='" .. xPlayer.identifier .. "'")
        Citizen.Wait(TimerWipe)
        MySQL.Sync.execute("DELETE FROM user_accounts WHERE identifier='" .. xPlayer.identifier .. "'")
        Citizen.Wait(TimerWipe)
        MySQL.Sync.execute("DELETE FROM billing WHERE identifier='" .. xPlayer.identifier .. "'")
        Citizen.Wait(TimerWipe)
        MySQL.Sync.execute("DELETE FROM open_car WHERE identifier='" .. xPlayer.identifier .. "'")
        Citizen.Wait(TimerWipe)
        MySQL.Sync.execute("DELETE FROM owned_vehicles WHERE owner='" .. xPlayer.identifier .. "'")
        Citizen.Wait(TimerWipe)
        --MySQL.Sync.execute("DELETE FROM impounded_vehicles WHERE owner='" .. xPlayer.identifier .. "'")
        MySQL.Sync.execute("DELETE FROM addon_inventory_items WHERE owner='" .. xPlayer.identifier .. "'")
        Citizen.Wait(TimerWipe)
        MySQL.Sync.execute("DELETE FROM addon_account_data WHERE owner='" .. xPlayer.identifier .. "'")
        Citizen.Wait(TimerWipe)
        MySQL.Sync.execute("DELETE FROM prop_owner WHERE owner='" .. xPlayer.identifier .. "'")
        Citizen.Wait(TimerWipe)
        MySQL.Sync.execute("DELETE FROM owned_vehicles WHERE owner='" .. xPlayer.identifier .. "'")
        Citizen.Wait(TimerWipe)
        MySQL.Sync.execute("DELETE FROM user_licenses WHERE owner='" .. xPlayer.identifier .. "'")
        Citizen.Wait(TimerWipe)
        MySQL.Sync.execute("DELETE FROM datastore_data WHERE owner='" .. xPlayer.identifier .. "'")
        Citizen.Wait(TimerWipe)
        MySQL.Sync.execute("DELETE FROM user_tattoos WHERE identifier='" .. xPlayer.identifier .. "'")
        Citizen.Wait(TimerWipe)
        MySQL.Sync.execute("DELETE FROM loaf_keys WHERE identifier='" .. xPlayer.identifier .. "'")
        Citizen.Wait(TimerWipe)
        MySQL.Sync.execute("DELETE FROM user_accounts WHERE identifier='" .. xPlayer.identifier .. "'")
        Citizen.Wait(TimerWipe)
        MySQL.Sync.execute("DELETE FROM user_inventory WHERE identifier='" .. xPlayer.identifier .. "'")
        Citizen.Wait(TimerWipe)
        MySQL.Sync.execute("DELETE FROM owned_bags WHERE identifier='" .. xPlayer.identifier .. "'")
        Citizen.Wait(TimerWipe)
        MySQL.Sync.execute("DELETE FROM datastore_data WHERE owner='" .. xPlayer.identifier .. "'")
        Citizen.Wait(TimerWipe)
        if isWebhookSet(Config.webhook.onWipe) then
            sendWebhook(("L'utilisateur %s a wipe %s"):format(GetPlayerName(source), name), "grey", Config.webhook.onWipe)
        end
    end
end)

RegisterNetEvent("adminmenu:giveBoutique")
AddEventHandler("adminmenu:giveBoutique", function(target, ammount)
    local source = source
    local rank = players[source].rank
    if not canUse("giveBoutique", rank) then
        DropPlayer(source, "Permission invalide")
        return
    end
    local xPlayer = ESX.GetPlayerFromId(target)
    local name = GetPlayerName(target)
    TriggerClientEvent("esx:showNotification", source, "~g~Give effectué")
    MySQL.Async.execute("UPDATE users SET falcoin = falcoin + "..ammount.." WHERE identifier='" .. xPlayer.identifier .. "';", {}, function() end)
    if isWebhookSet(Config.webhook.onGive) then
        sendWebhook(("L'utilisateur %s a give des pts boutiques a %s"):format(GetPlayerName(source), name), "grey", Config.webhook.onGive)
    end
end)

RegisterNetEvent("adminmenu:fixname")
AddEventHandler("adminmenu:fixname", function(target, ammount)
    local source = source
    local rank = players[source].rank
    if not canUse("wipe", rank) then
        DropPlayer(source, "Permission invalide")
        return
    end
    local xPlayer = ESX.GetPlayerFromId(target)
    local name = GetPlayerName(target)
    TriggerClientEvent("esx:showNotification", source, "~g~Modification effectué")
    MySQL.Async.execute("UPDATE users SET firstname = '" ..ammount.."' WHERE identifier='" .. xPlayer.identifier .. "';", {}, function() end)
    if isWebhookSet(Config.webhook.onGive) then
        sendWebhook(("L'utilisateur %s a fait une modification sur le prénom de %s"):format(GetPlayerName(source), name), "grey", Config.webhook.onGive)
    end
end)

RegisterNetEvent("adminmenu:fixlastname")
AddEventHandler("adminmenu:fixlastname", function(target, ammount)
    local source = source
    local rank = players[source].rank
    if not canUse("wipe", rank) then
        DropPlayer(source, "Permission invalide")
        return
    end
    local xPlayer = ESX.GetPlayerFromId(target)
    local name = GetPlayerName(target)
    TriggerClientEvent("esx:showNotification", source, "~g~Modification effectué")
    MySQL.Async.execute("UPDATE users SET lastname = '" ..ammount.."' WHERE identifier='" .. xPlayer.identifier .. "';", {}, function() end)
    if isWebhookSet(Config.webhook.onGive) then
        sendWebhook(("L'utilisateur %s a fait une modification sur le nom de %s"):format(GetPlayerName(source), name), "grey", Config.webhook.onGive)
    end
end)

RegisterNetEvent("adminmenu:fixnaissance")
AddEventHandler("adminmenu:fixnaissance", function(target, ammount)
    local source = source
    local rank = players[source].rank
    if not canUse("wipe", rank) then
        DropPlayer(source, "Permission invalide")
        return
    end
    local xPlayer = ESX.GetPlayerFromId(target)
    local name = GetPlayerName(target)
    TriggerClientEvent("esx:showNotification", source, "~g~Modification effectué")
    MySQL.Async.execute("UPDATE users SET dateofbirth = '" ..ammount.."' WHERE identifier='" .. xPlayer.identifier .. "';", {}, function() end)
    if isWebhookSet(Config.webhook.onGive) then
        sendWebhook(("L'utilisateur %s a fait une modification sur la date de naissance de %s"):format(GetPlayerName(source), name), "grey", Config.webhook.onGive)
    end
end)

RegisterNetEvent("adminmenu:fixtaille")
AddEventHandler("adminmenu:fixtaille", function(target, ammount)
    local source = source
    local rank = players[source].rank
    if not canUse("wipe", rank) then
        DropPlayer(source, "Permission invalide")
        return
    end
    local xPlayer = ESX.GetPlayerFromId(target)
    local name = GetPlayerName(target)
    TriggerClientEvent("esx:showNotification", source, "~g~Modification effectué")
    MySQL.Async.execute("UPDATE users SET height = '" ..ammount.."' WHERE identifier='" .. xPlayer.identifier .. "';", {}, function() end)
    if isWebhookSet(Config.webhook.onGive) then
        sendWebhook(("L'utilisateur %s a fait une modification sur la taille de %s"):format(GetPlayerName(source), name), "grey", Config.webhook.onGive)
    end
end)

RegisterNetEvent("adminmenu:fixsexe")
AddEventHandler("adminmenu:fixsexe", function(target, ammount)
    local source = source
    local rank = players[source].rank
    if not canUse("wipe", rank) then
        DropPlayer(source, "Permission invalide")
        return
    end
    local xPlayer = ESX.GetPlayerFromId(target)
    local name = GetPlayerName(target)
    TriggerClientEvent("esx:showNotification", source, "~g~Modification effectué")
    MySQL.Async.execute("UPDATE users SET sex = '" ..ammount.."' WHERE identifier='" .. xPlayer.identifier .. "';", {}, function() end)
    if isWebhookSet(Config.webhook.onGive) then
        sendWebhook(("L'utilisateur %s a fait une modification sur le sexe de %s"):format(GetPlayerName(source), name), "grey", Config.webhook.onGive)
    end
end)

RegisterNetEvent("adminmenu:mettregarage")
AddEventHandler("adminmenu:mettregarage", function(plaque)
    local source = source
    local rank = players[source].rank
    if not canUse("vehicles", rank) then
        DropPlayer(source, "Permission invalide")
        return
    end
    local xPlayer = ESX.GetPlayerFromId(target)
    Citizen.Wait(100)
    MySQL.Async.execute("UPDATE owned_vehicles SET stored = 1 WHERE plate='" ..plaque.."';", {}, function() end)
    if isWebhookSet(Config.webhook.onGive) then
        sendWebhook(("L'utilisateur %s a remis le véhicule" .. plaque .." au garage"):format(GetPlayerName(source), name), "grey", Config.webhook.onGive)
    end
end)

RegisterNetEvent("adminmenu:rmtempkeys")
AddEventHandler("adminmenu:rmtempkeys", function(plaque)
    local source = source
    local rank = players[source].rank
    if not canUse("vehicles", rank) then
        DropPlayer(source, "Permission invalide")
        return
    end
    local xPlayer = ESX.GetPlayerFromId(target)
    Citizen.Wait(100)
    MySQL.Async.execute("DELETE FROM `open_car` WHERE NB = 2;", {}, function() end)
    if isWebhookSet(Config.webhook.onGive) then
        sendWebhook(("L'utilisateur %s supprime toutes les clés temporaire du serveur"):format(GetPlayerName(source), name), "grey", Config.webhook.onGive)
    end
end)

RegisterNetEvent("adminmenu:boblepongecarre")
AddEventHandler("adminmenu:boblepongecarre", function(plaque)
    local xPlayers = ESX.GetPlayers()
    --ESX.SavePlayers(cb)
    Citizen.Wait(5000)
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        ESX.SavePlayer(xPlayer, cb)
        Citizen.Wait(1000)
        xPlayer.kick("🌙 Street Kings: Restart du serveur en cours.")
    end
    if isWebhookSet(Config.webhook.onGive) then
        sendWebhook(("L'utilisateur %s Kick tous les joueurs pour un reboot"):format(GetPlayerName(source), name), "grey", Config.webhook.onGive)
    end
end)


RegisterNetEvent("adminmenu:spawnVehicle")
AddEventHandler("adminmenu:spawnVehicle", function(model, target)
    local source = source
    local rank = players[source].rank
    if not canUse("vehicles", rank) then
        DropPlayer(source, "Permission invalide")
        return
    end
    if target ~= nil then
        TriggerClientEvent("esx:spawnVehicle", target, model)
    else
        TriggerClientEvent("esx:spawnVehicle", source, model)
    end
end)

RegisterNetEvent("adminmenu:setGroup")
AddEventHandler("adminmenu:setGroup", function(target, group)
    local source = source
    local rank = players[source].rank
    if not canUse("setGroup", rank) then
        DropPlayer(source, "Permission invalide")
        return
    end
    local xPlayer = ESX.GetPlayerFromId(target)
    if xPlayer then
        xPlayer.setGroup(group)
        ESX.SavePlayer(xPlayer, function() end)
        players[source].rank = group
        TriggerClientEvent("adminmenu:cbPermLevel", target, group)
        TriggerClientEvent("esx:showNotification", source, ("~g~Changement du rang de %s effectué"):format(GetPlayerName(target)))
        for source, player in pairs(players) do
            if isStaff(source) then
                TriggerClientEvent("adminmenu:updatePlayers", source, players)
            end
        end
        local name = GetPlayerName(target)
        if isWebhookSet(Config.webhook.onGroupChange) then
            sendWebhook(("L'utilisateur %s a changé le groupe de %s pour le groupe: __%s__"):format(GetPlayerName(source), name, group), "red", Config.webhook.onGroupChange)
        end
    else
        TriggerClientEvent("esx:showNotification", source, "~r~Ce joueur n'est plus connecté")
    end
end)

RegisterNetEvent("adminmenu:clearInv")
AddEventHandler("adminmenu:clearInv", function(target)
    local source = source
    local rank = players[source].rank
    if not canUse("clearInventory", rank) then
        DropPlayer(source, "Permission invalide")
        return
    end
    local xPlayer = ESX.GetPlayerFromId(target)
    for i = 1, #xPlayer.inventory, 1 do
        if xPlayer.inventory[i].count > 0 then
            xPlayer.setInventoryItem(xPlayer.inventory[i].name, 0)
        end
    end
    TriggerClientEvent("esx:showNotification", source, ("~g~Clear inventaire de %s effectuée"):format(GetPlayerName(target)))
    if isWebhookSet(Config.webhook.onClear) then
        sendWebhook(("L'utilisateur %s a clear inventaire %s"):format(GetPlayerName(source), GetPlayerName(target)), "grey", Config.webhook.onClear)
    end
end)


RegisterNetEvent("adminmenu:clearLoadout")
AddEventHandler("adminmenu:clearLoadout", function(target)
    local source = source
    local rank = players[source].rank
    if not canUse("clearLoadout", rank) then
        DropPlayer(source, "Permission invalide")
        return
    end
    local xPlayer = ESX.GetPlayerFromId(target)
    for i = #xPlayer.loadout, 1, -1 do
        xPlayer.removeWeapon(xPlayer.loadout[i].name)
    end
    TriggerClientEvent("esx:showNotification", source, ("~g~Clear des armes de %s effectuée"):format(GetPlayerName(target)))
    if isWebhookSet(Config.webhook.onClear) then
        sendWebhook(("L'utilisateur %s a clear les armes de %s"):format(GetPlayerName(source), GetPlayerName(target)), "grey", Config.webhook.onClear)
    end
end)

RegisterNetEvent("adminmenu:addMoney")
AddEventHandler("adminmenu:addMoney", function(target, ammount)
    local source = source
    local rank = players[source].rank
    if not canUse("giveMoney", rank) then
        DropPlayer(source, "Permission invalide")
        return
    end
    local xPlayer = ESX.GetPlayerFromId(target)
    local argentcash = tonumber(ammount)
    xPlayer.addMoney(argentcash)
    TriggerClientEvent("esx:showNotification", source, ("~g~Give d'argent à %s effectuée"):format(GetPlayerName(target)))
    if isWebhookSet(Config.webhook.onMoneyGive) then
        sendWebhook(("L'utilisateur %s a give %s$ à %s"):format(GetPlayerName(source), ammount, GetPlayerName(target)), "grey", Config.webhook.onMoneyGive)
    end
end)

-- Players updaters task
Citizen.CreateThread(function()
    while true do
        Wait(15000)
        for source, player in pairs(players) do
            if isStaff(source) then
                TriggerClientEvent("adminmenu:updatePlayers", source, players)
                TriggerClientEvent("adminmenu:cbReportTable", source, reportsTable)
            end
        end
    end
end)

RegisterServerEvent("euhtesserieuxmek")
AddEventHandler("euhtesserieuxmek", function()
    local _source = source
    TriggerEvent("BanSql:ICheatServer", _source, "Le cheat ... c'est mal !")
end)

AddEventHandler("clearPedTasksEvent", function(source, data)
    local _source = source
    TriggerEvent("BanSql:ICheatServer", _source, "Le cheat ... c'est mal !")
    --print("~y~ID: ".._source.." a essayé de truc")
end)

-- Session counter task
-- TODO -> add report time elapsed
Citizen.CreateThread(function()
    while true do
        Wait(1000 * 60)
        for k, v in pairs(players) do
            players[k].timePlayed[1] = players[k].timePlayed[1] + 1
            if players[k].timePlayed[1] > 60 then
                players[k].timePlayed[1] = 0
                players[k].timePlayed[2] = players[k].timePlayed[2] + 1
            end
        end
        for k, v in pairs(reportsTable) do
            reportsTable[k].timeElapsed[1] = reportsTable[k].timeElapsed[1] + 1
            if reportsTable[k].timeElapsed[1] > 60 then
                reportsTable[k].timeElapsed[1] = 0
                reportsTable[k].timeElapsed[2] = reportsTable[k].timeElapsed[2] + 1
            end
        end
    end
end)