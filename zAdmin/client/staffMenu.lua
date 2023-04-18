local isMenuOpened, cat = false, "adminmenu"
local prefix = "~r~[Admin]~s~"
local filterArray = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" }
local filter = 1
local creditsSent = false


local hideTakenReports = false

local function subCat(name)
    return cat .. name
end

local function msg(string)
    ESX.ShowNotification(string)
end

local function colorByState(bool)
    if bool then
        return "~g~"
    else
        return "~s~"
    end
end

local function statsSeparator()
    RageUI.Separator("Connectés: ~g~" .. connecteds .. " ~b~|~s~ Staff en ligne: ~o~" .. staff)
end

local function generateTakenBy(reportID)
    if localReportsTable[reportID].taken then
        return "~s~ | Pris par: ~o~" .. localReportsTable[reportID].takenBy
    else
        return ""
    end
end

local ranksRelative = {
    ["user"] = 1,
    ["admin"] = 2,
    ["superadmin"] = 3,
    ["_dev"] = 4
}

local ranksInfos = {
    [1] = { label = "Joueur", rank = "user" },
    [2] = { label = "Admin", rank = "admin" },
    [3] = { label = "Super Admin", rank = "superadmin" },
    [4] = { label = "Développeur", rank = "_dev" }
}

local function getRankDisplay(rank)
    local ranks = {
        ["_dev"] = "~r~[Dev] ~s~",
        ["superadmin"] = "~r~[S.Admin] ~s~",
        ["admin"] = "~r~[Admin] ~s~",
    }
    return ranks[rank] or ""
end

local function getIsTakenDisplay(bool)
    if bool then
        return ""
    else
        return "~r~[EN ATTENTE]~s~ "
    end
end

local function starts(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end

function openMenu()
    if menuOpen then
        return
    end
    if permLevel == "user" then
        ESX.ShowNotification("~r~Vous n'avez pas accès à ce menu.")
        return
    end
    local selectedColor = 1
    local cVarLongC = { "~p~", "~r~", "~o~", "~y~", "~c~", "~g~", "~b~" }
    local cVar1, cVar2 = "~y~", "~r~"
    local cVarLong = function()
        return cVarLongC[selectedColor]
    end
    menuOpen = true

    RMenu.Add(cat, subCat("main"), RageUI.CreateMenu("Administration", "Menu administratif"))
    RMenu:Get(cat, subCat("main")).Closed = function()
    end

    RMenu.Add(cat, subCat("players"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("main")), "Administration", "Menu administratif"))
    RMenu:Get(cat, subCat("players")).Closed = function()
    end

    RMenu.Add(cat, subCat("reports"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("main")), "Administration", "Menu administratif"))
    RMenu:Get(cat, subCat("reports")).Closed = function()
    end

    RMenu.Add(cat, subCat("reports_take"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("reports")), "Administration", "Menu administratif"))
    RMenu:Get(cat, subCat("reports_take")).Closed = function()
    end

    RMenu.Add(cat, subCat("playersManage"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("players")), "Administration", "Menu administratif"))
    RMenu:Get(cat, subCat("playersManage")).Closed = function()
    end

    RMenu.Add(cat, subCat("setGroup"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("playersManage")), "Administration", "Menu administratif"))
    RMenu:Get(cat, subCat("setGroup")).Closed = function()
    end

    RMenu.Add(cat, subCat("items"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("playersManage")), "Administration", "Menu administratif"))
    RMenu:Get(cat, subCat("items")).Closed = function()
    end

    RMenu.Add(cat, subCat("vehicle"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("main")), "Administration", "Menu administratif"))
    RMenu:Get(cat, subCat("vehicle")).Closed = function()
    end

    RageUI.Visible(RMenu:Get(cat, subCat("main")), true)
    Citizen.CreateThread(function()
        while menuOpen do
            Wait(800)
            if cVar1 == "~y~" then
                cVar1 = "~o~"
            else
                cVar1 = "~y~"
            end
            if cVar2 == "~r~" then
                cVar2 = "~s~"
            else
                cVar2 = "~r~"
            end
        end
    end)
    Citizen.CreateThread(function()
        while menuOpen do
            Wait(250)
            selectedColor = selectedColor + 1
            if selectedColor > #cVarLongC then
                selectedColor = 1
            end
        end
    end)
    Citizen.CreateThread(function()
        while menuOpen do
            local shouldStayOpened = false
            RageUI.IsVisible(RMenu:Get(cat, subCat("main")), true, true, true, function()
                shouldStayOpened = true
                statsSeparator()

                if isStaffMode then
                    RageUI.ButtonWithStyle("~r~Désactiver le Staff Mode", nil, {}, not serverInteraction, function(_, _, s)
                        if s then
                            serverInteraction = true
                            blipsActive = false
                            ESX.ShowNotification("~y~Désactivation du StaffMode...")
                            TriggerServerEvent("adminmenu:setStaffState", false)
                            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                                TriggerEvent('skinchanger:loadSkin', skin)
                            end)
                        end
                    end)
                else
                    RageUI.ButtonWithStyle("~g~Activer le Staff Mode", nil, {}, not serverInteraction, function(_, _, s)
                        if s then
                            serverInteraction = true
                            ESX.ShowNotification("~y~Activation du StaffMode...")
                            TriggerServerEvent("adminmenu:setStaffState", true)
                        end
                    end)
                end

                RageUI.Separator("↓ ~g~Assistance ~s~↓")
                RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Gestion des reports (~r~" .. reportCount .. "~s~)", nil, { RightLabel = "→→" }, isStaffMode, function(_, _, s)
                end, RMenu:Get(cat, subCat("reports")))

                if isStaffMode then
                    RageUI.Separator("↓ ~y~Modération ~s~↓")

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Gestion joueurs", nil, { RightLabel = "→→" }, true, function()
                    end, RMenu:Get(cat, subCat("players")))
                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Gestion véhicules", nil, { RightLabel = "→→" }, true, function()
                    end, RMenu:Get(cat, subCat("vehicle")))
                    RageUI.Separator("↓ ~o~Personnel ~s~↓")
                    RageUI.Checkbox(cVarLong() .. "→ " .. colorByState(isNoClip) .. "NoClip", nil, isNoClip, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
                        isNoClip = Checked;
                    end, function()
                        NoClip(true)
                    end, function()
                        NoClip(false)
                    end)

                    -- TODO -> Faire avec les DecorSetInt le grade du joueur et faire les couleurs avec les mpGamerTag
                   -- RageUI.Checkbox(cVarLong() .. "→ " .. colorByState(isNameShown) .. "Affichage des noms", nil, isNameShown, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
                   --     isNameShown = Checked;
                   -- end, function()
                   --     showNames(true)
                   -- end, function()
                   --     showNames(false)
                   -- end)


                    --RageUI.Checkbox(cVarLong() .. "→ " .. colorByState(blipsActive) .. "Affichage des blips", nil, blipsActive, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
                    --    blipsActive = Checked;
                    --end, function()
                    --end, function()
                    --end)

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Annonce Reboot 19H00", nil, { RightLabel = "→→" }, canUse("wipe", permLevel), function(Hovered, Active, Selected)
                        if Selected then
                            ESX.ShowNotification("~y~Annonce du reboot de 19h00...")
                            ExecuteCommand("announce Reboot du serveur a 19h00, merci de votre compréhension !")
                        end
                    end)


                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Annonce Reboot Proche", nil, { RightLabel = "→→" }, canUse("wipe", permLevel), function(Hovered, Active, Selected)
                        if Selected then
                            ESX.ShowNotification("~y~Annonce du reboot dans pas longtemps...")
                            ExecuteCommand("announce Reboot du serveur imminent, merci de vous mettre en sécurité !")
                        end
                    end)

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Reboot Sauvegarde et Kick", nil, { RightLabel = "→→" }, canUse("wipe", permLevel), function(Hovered, Active, Selected)
                        if Selected then
                            local validation = input("Restart ? Oui ou Non", "", 20, true)
                            if validation ~= nil then
                            TriggerServerEvent("adminmenu:boblepongecarre")
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Activer les Blips", nil, { RightLabel = "→→" }, canUse("revive", permLevel), function(Hovered, Active, Selected)
                        if Selected then
                            blipsActive = true
                        end
                    end)

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Désactiver les Blips", nil, { RightLabel = "→→" }, canUse("revive", permLevel), function(Hovered, Active, Selected)
                        if Selected then
                            blipsActive = false
                        end
                    end)

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Activer les noms", nil, { RightLabel = "→→" }, canUse("revive", permLevel), function(Hovered, Active, Selected)
                        if Selected then
                            showNames(true)
                        end
                    end)

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Désactiver les noms", nil, { RightLabel = "→→" }, canUse("revive", permLevel), function(Hovered, Active, Selected)
                        if Selected then
                            showNames(false)
                        end
                    end)

                end
            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("players")), true, true, true, function()
                shouldStayOpened = true
                statsSeparator()
                RageUI.Checkbox(cVarLong() .. "→ " .. colorByState(showAreaPlayers) .. "Restreindre à ma zone", nil, showAreaPlayers, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
                    showAreaPlayers = Checked;
                end, function()
                end, function()
                end)
                RageUI.Separator("↓ ~g~Joueurs ~s~↓")
                if not showAreaPlayers then
                    for source, player in pairs(localPlayers) do
                        RageUI.ButtonWithStyle(getRankDisplay(player.rank) .. "~s~[~o~" .. source .. "~s~] " .. cVarLong() .. "→ ~s~" .. player.name or "<Pseudo invalide>" .. " (~b~" .. player.timePlayed[2] .. "h " .. player.timePlayed[1] .. "min~s~)", nil, { RightLabel = "→→" }, ranksRelative[permLevel] >= ranksRelative[player.rank] and source ~= GetPlayerServerId(PlayerId()), function(_, _, s)
                            if s then
                                selectedPlayer = source
                            end
                        end, RMenu:Get(cat, subCat("playersManage")))
                    end
                else
                    for _, player in ipairs(GetActivePlayers()) do
                        local sID = GetPlayerServerId(player)
                        if localPlayers[sID] ~= nil then
                            RageUI.ButtonWithStyle(getRankDisplay(localPlayers[sID].rank) .. "~s~[~o~" .. sID .. "~s~] " .. cVarLong() .. "→ ~s~" .. localPlayers[sID].name or "<Pseudo invalide>" .. " (~b~" .. localPlayers[sID].timePlayed[2] .. "h " .. localPlayers[sID].timePlayed[1] .. "min~s~)", nil, { RightLabel = "→→" }, ranksRelative[permLevel] >= ranksRelative[localPlayers[sID].rank] and source ~= GetPlayerServerId(PlayerId()), function(_, _, s)
                                if s then
                                    selectedPlayer = sID
                                end
                            end, RMenu:Get(cat, subCat("playersManage")))
                        end
                    end
                end
            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("reports")), true, true, true, function()
                shouldStayOpened = true
                statsSeparator()
                RageUI.Separator("↓ ~g~Paramètres ~s~↓")
                RageUI.Checkbox(colorByState(hideTakenReports) .. "Cacher les pris en charge", nil, hideTakenReports, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
                    hideTakenReports = Checked;
                end, function()
                end, function()
                end)
                RageUI.Separator("↓ ~y~Reports ~s~↓")
                for sender, infos in pairs(localReportsTable) do
                    if infos.taken then
                        if hideTakenReports == false then
                            RageUI.ButtonWithStyle(getIsTakenDisplay(infos.taken) .. "[~b~" .. infos.id .. "~s~] " .. cVarLong() .. "→ ~s~" .. infos.name, "~g~Créé il y a~s~: "..infos.timeElapsed[1].."m"..infos.timeElapsed[2].."h~n~~b~ID Unique~s~: #" .. infos.id .. "~n~~y~Description~s~: " .. infos.reason .. "~n~~o~Pris en charge par~s~: " .. infos.takenBy, { RightLabel = "→→" }, true, function(_, _, s)
                                if s then
                                    selectedReport = sender
                                end
                            end, RMenu:Get(cat, subCat("reports_take")))
                        end
                    else
                        RageUI.ButtonWithStyle(getIsTakenDisplay(infos.taken) .. "[~b~" .. infos.id .. "~s~] " .. cVarLong() .. "→ ~s~" .. infos.name, "~g~Créé il y a~s~: "..infos.timeElapsed[1].."m"..infos.timeElapsed[2].."h~n~~b~ID Unique~s~: #" .. infos.id .. "~n~~y~Description~s~: " .. infos.reason, { RightLabel = "→→" }, true, function(_, _, s)
                            if s then
                                selectedReport = sender
                            end
                        end, RMenu:Get(cat, subCat("reports_take")))
                    end
                end
            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("reports_take")), true, true, true, function()
                shouldStayOpened = true
                statsSeparator()
                if localReportsTable[selectedReport] ~= nil then
                    RageUI.Separator("ID du Report: ~b~#" .. localReportsTable[selectedReport].uniqueId .. " ~s~| ID de l'auteur: ~y~" .. selectedReport .. generateTakenBy(selectedReport))
                    RageUI.Separator("↓ ~g~Actions sur le report ~s~↓")
                    local infos = localReportsTable[selectedReport]
                    if not localReportsTable[selectedReport].taken then
                        RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Prendre en charge ce report", "~y~Description~s~: " .. infos.reason, { RightLabel = "→→" }, true, function(_, _, s)
                            if s then
                                TriggerServerEvent("adminmenu:takeReport", selectedReport)
                            end
                        end)
                    end
                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Cloturer ce report", "~y~Description~s~: " .. infos.reason, { RightLabel = "→→" }, true, function(_, _, s)
                        if s then
                            TriggerServerEvent("adminmenu:closeReport", selectedReport)
                        end
                    end)
                    RageUI.Separator("↓ ~y~Actions rapides ~s~↓")
                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Revive", "~y~Description~s~: " .. infos.reason, { RightLabel = "→→" }, canUse("revive", permLevel), function(_, _, s)
                        if s then
                            ESX.ShowNotification("~y~Revive du joueur en cours...")
                            TriggerServerEvent("adminmenu:revive", selectedReport)
                        end
                    end)

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Soigner", "~y~Description~s~: " .. infos.reason, { RightLabel = "→→" }, canUse("revive", permLevel), function(_, _, s)
                        if s then
                            ESX.ShowNotification("~y~Heal du joueur en cours...")
                            TriggerServerEvent("adminmenu:heal", selectedReport)
                        end
                    end)

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~TP sur lui", nil, { RightLabel = "→→" }, true, function(_, _, s)
                        if s then
                            TriggerServerEvent("adminmenu:goto", selectedReport)
                        end
                    end)
                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~TP sur moi", nil, { RightLabel = "→→" }, true, function(_, _, s)
                        if s then
                            TriggerServerEvent("adminmenu:bring", selectedReport, GetEntityCoords(PlayerPedId()))
                        end
                    end)

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~TP Parking Pole Emploi", "~y~Description~s~: " .. infos.reason, { RightLabel = "→→" }, canUse("tppc", permLevel), function(_, _, s)
                        if s then
                            ESX.ShowNotification("~y~Téléportation du joueur en cours...")
                            TriggerServerEvent("adminmenu:tppc", selectedReport)
                        end
                    end)

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~TP Hopital", "~y~Description~s~: " .. infos.reason, { RightLabel = "→→" }, canUse("tppc", permLevel), function(_, _, s)
                        if s then
                            ESX.ShowNotification("~y~Téléportation du joueur en cours...")
                            TriggerServerEvent("adminmenu:tphopi", selectedReport)
                        end
                    end)

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~TP PDP", "~y~Description~s~: " .. infos.reason, { RightLabel = "→→" }, canUse("tppc", permLevel), function(_, _, s)
                        if s then
                            ESX.ShowNotification("~y~Téléportation du joueur en cours...")
                            TriggerServerEvent("adminmenu:tppdp", selectedReport)
                        end
                    end)

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~y~Actions avancées", "~y~Description~s~: " .. infos.reason.."~n~~r~Attention~s~: Cette action vous fera changer de menu", { RightLabel = "→→" }, GetPlayerServerId(PlayerId()) ~= selectedReport, function(_, _, s)
                        if s then
                            selectedPlayer = selectedReport
                        end
                    end,RMenu:Get(cat,subCat("playersManage")))
                else
                    RageUI.Separator("")
                    RageUI.Separator(cVar2 .. "Ce report n'est plus valide")
                    RageUI.Separator("")
                end
            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("playersManage")), true, true, true, function()
                shouldStayOpened = true
                if not localPlayers[selectedPlayer] then
                    RageUI.Separator("")
                    RageUI.Separator(cVar2 .. "Ce joueur n'est plus connecté !")
                    RageUI.Separator("")
                else
                    statsSeparator()
                    RageUI.Separator("Gestion: ~y~" .. localPlayers[selectedPlayer].name .. " ~s~(~o~" .. selectedPlayer .. "~s~)")
                    RageUI.Separator("↓ ~g~Téléportation ~s~↓")
                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Fouiller le joueur", nil, { RightLabel = "→→" }, canUse("revive", permLevel), function(_, _, s)
                        if s then
                            ESX.ShowNotification("~y~Recherche de l'inventaire en cours...")
                            RageUI.CloseAll()
                            Citizen.Wait(1000)
                            TriggerEvent('fellow:MenuLh82wC34JaF3AGze6pFouilleAdmin')
                        end
                    end)
                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~S'y téléporter", nil, { RightLabel = "→→" }, true, function(_, _, s)
                        if s then
                            TriggerServerEvent("adminmenu:goto", selectedPlayer)
                        end
                    end)
                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Téléporter sur moi", nil, { RightLabel = "→→" }, true, function(_, _, s)
                        if s then
                            TriggerServerEvent("adminmenu:bring", selectedPlayer, GetEntityCoords(PlayerPedId()))
                        end
                    end)
                    RageUI.Separator("↓ ~y~Modération ~s~↓")
                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Message", nil, { RightLabel = "→→" }, canUse("mess", permLevel), function(_, _, s)
                        if s then
                            local reason = input("Message", "", 100, false)
                            if reason ~= nil and reason ~= "" then
                                ESX.ShowNotification("~y~Envoie du message en cours...")
                                TriggerServerEvent("adminmenu:message", selectedPlayer, reason)
                            end
                        end
                    end)
                    
                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Warn", nil, { RightLabel = "→→" }, canUse("warn", permLevel), function(_, _, s)
                        if s then
                            local reason = input("Warn", "", 100, false)
                            if reason ~= nil and reason ~= "" then
                                ESX.ShowNotification("~y~Envoie du warn en cours...")
                                TriggerServerEvent("adminmenu:warn", selectedPlayer, reason)
                            end
                        end
                    end)
                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Kick", nil, { RightLabel = "→→" }, canUse("kick", permLevel), function(_, _, s)
                        if s then
                            local reason = input("Raison", "", 80, false)
                            if reason ~= nil and reason ~= "" then
                                ESX.ShowNotification("~y~Application de la sanction en cours...")
                                TriggerServerEvent("adminmenu:kick", selectedPlayer, reason)
                            end
                        end
                    end)
                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Bannir", nil, { RightLabel = "→→" }, canUse("ban", permLevel), function(_, _, s)
                        if s then
                            local days = input("Durée du banissement (en jours)", "", 20, true)
                            if days ~= nil then
                                local reason = input("Raison", "", 80, false)
                                if reason ~= nil then
                                    ESX.ShowNotification("~y~Application de la sanction en cours...")
                                    ExecuteCommand(("sqlban %s %s %s"):format(selectedPlayer, days, reason))
                                end
                            end
                        end
                    end)
                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Changer le groupe", nil, { RightLabel = "→→" }, canUse("setGroup", permLevel), function(_, _, s)
                    end, RMenu:Get(cat, subCat("setGroup")))
                    RageUI.Separator("↓ ~o~Personnage ~s~↓")

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Revive", nil, { RightLabel = "→→" }, canUse("revive", permLevel), function(_, _, s)
                        if s then
                            ESX.ShowNotification("~y~Revive du joueur en cours...")
                            TriggerServerEvent("adminmenu:revive", selectedPlayer)
                        end
                    end)

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Soigner", nil, { RightLabel = "→→" }, canUse("revive", permLevel), function(_, _, s)
                        if s then
                            ESX.ShowNotification("~y~Heal du joueur en cours...")
                            TriggerServerEvent("adminmenu:heal", selectedPlayer)
                        end
                    end)

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Donner un véhicule", nil, { RightLabel = "→→" }, canUse("vehicles", permLevel), function(Hovered, Active, Selected)
                        if Selected then
                            local veh = CustomString()
                            if veh ~= nil then
                                local model = GetHashKey(veh)
                                if IsModelValid(model) then
                                    RequestModel(model)
                                    while not HasModelLoaded(model) do
                                        Wait(1)
                                    end
                                    TriggerServerEvent("adminmenu:spawnVehicle", model, selectedPlayer)
                                else
                                    msg("Ce modèle n'existe pas")
                                end
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Clear inventaire", nil, { RightLabel = "→→" }, canUse("clearInventory", permLevel), function(_, _, s)
                        if s then
                            ESX.ShowNotification("~y~Clear de l'inventaire du joueur en cours...")
                            TriggerServerEvent("adminmenu:clearInv", selectedPlayer)
                        end
                    end)
                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Clear armes", nil, { RightLabel = "→→" }, canUse("clearLoadout", permLevel), function(_, _, s)
                        if s then
                            ESX.ShowNotification("~y~Clear des armes du joueur en cours...")
                            TriggerServerEvent("adminmenu:clearLoadout", selectedPlayer)
                        end
                    end)

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Give un item", nil, { RightLabel = "→→" }, canUse("give", permLevel), function(_, _, s)
                    end, RMenu:Get(cat, subCat("items")))

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Give de l'argent (~g~liquide~s~)", nil, { RightLabel = "→→" }, canUse("giveMoney", permLevel), function(_, _, s)
                        if s then
                            local qty = input("Quantité", "", 20, true)
                            if qty ~= nil then
                                ESX.ShowNotification("~y~Don de l'argent au joueur...")
                                TriggerServerEvent("adminmenu:addMoney", selectedPlayer, qty)
                            end
                        end
                    end)


                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Mettre un Prénom", nil, { RightLabel = "→→" }, canUse("wipe", permLevel), function(_, _, s)
                        if s then
                            local prenom = input("Prénom", "", 80, false)
                            if prenom ~= nil and prenom ~= "" then
                                ESX.ShowNotification("~y~Modification du nom en cours...")
                                TriggerServerEvent("adminmenu:fixname", selectedPlayer, prenom)
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Mettre un Nom", nil, { RightLabel = "→→" }, canUse("wipe", permLevel), function(_, _, s)
                        if s then
                            local nom = input("Nom", "", 80, false)
                            if nom ~= nil and nom ~= "" then
                                ESX.ShowNotification("~y~Modification du nom en cours...")
                                TriggerServerEvent("adminmenu:fixlastname", selectedPlayer, nom)
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Mettre une Date de Naissance", nil, { RightLabel = "→→" }, canUse("wipe", permLevel), function(_, _, s)
                        if s then
                            local datenaissance = input("Date de Naissance au format (Jours/Mois/Année) exemple 03/05/1993", "", 80, false)
                            if datenaissance ~= nil and datenaissance ~= "" then
                                ESX.ShowNotification("~y~Modification de la date de naissance en cours...")
                                TriggerServerEvent("adminmenu:fixnaissance", selectedPlayer, datenaissance)
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Mettre une Taille", nil, { RightLabel = "→→" }, canUse("wipe", permLevel), function(_, _, s)
                        if s then
                            local tailleperso = input("Taille du personnage en CM exemple 1M80 = 180", "", 80, false)
                            if tailleperso ~= nil and tailleperso ~= "" then
                                ESX.ShowNotification("~y~Modification de la taille du personnage en cours...")
                                TriggerServerEvent("adminmenu:fixtaille", selectedPlayer, tailleperso)
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Mettre un Sexe", nil, { RightLabel = "→→" }, canUse("wipe", permLevel), function(_, _, s)
                        if s then
                            local sexu = input("Sexe du personnage ? | M pour Masculin | F pour Féminin", "", 80, false)
                            if sexu ~= nil and sexu ~= "" then
                                ESX.ShowNotification("~y~Modification du Sexe en cours Ouuuuuuh...")
                                TriggerServerEvent("adminmenu:fixsexe", selectedPlayer, sexu)
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Wipe", nil, { RightLabel = "→→" }, canUse("wipe", permLevel), function(_, _, s)
                        if s then
                            local validation = input("Oui ou Non", "", 20, true)
                            if validation ~= nil then
                            ESX.ShowNotification("~b~Wipe du joueur en cours...")
                            TriggerServerEvent("adminmenu:wipe", selectedPlayer)
                            else
                            ESX.ShowNotification("~y~Pas de validation on annule le Wipe...")
                            end
                        end
                    end)

                end
            end, function()
            end, 1)

            --
            
            --

            RageUI.IsVisible(RMenu:Get(cat, subCat("items")), true, true, true, function()
                shouldStayOpened = true
                statsSeparator()
                RageUI.Separator("Gestion: ~y~" .. localPlayers[selectedPlayer].name .. " ~s~(~o~" .. selectedPlayer .. "~s~)")
                RageUI.List("Filtre:", filterArray, filter, nil, {}, true, function(_, _, _, i)
                    filter = i
                end)
                RageUI.Separator("↓ ~g~Items disponibles ~s~↓")
                for id, itemInfos in pairs(items) do
                    if starts(itemInfos.label:lower(), filterArray[filter]:lower()) then
                        RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~" .. itemInfos.label, nil, { RightLabel = "~b~Donner ~s~→→" }, true, function(_, _, s)
                            if s then
                                local qty = input("Quantité", "", 20, true)
                                if qty ~= nil then
                                    ESX.ShowNotification("~y~Give de l'item...")
                                    TriggerServerEvent("adminmenu:give", selectedPlayer, itemInfos.name, qty)
                                end
                            end
                        end)
                    end
                end
            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("setGroup")), true, true, true, function()
                shouldStayOpened = true
                statsSeparator()
                RageUI.Separator("Gestion: ~y~" .. localPlayers[selectedPlayer].name .. " ~s~(~o~" .. selectedPlayer .. "~s~)")
                RageUI.Separator("↓ ~g~Rangs disponibles ~s~↓")
                for i = 1, #ranksInfos do
                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~" .. ranksInfos[i].label, nil, { RightLabel = "~b~Attribuer ~s~→→" }, ranksRelative[permLevel] > i, function(_, _, s)
                        if s then
                            ESX.ShowNotification("~y~Application du rang...")
                            TriggerServerEvent("adminmenu:setGroup", selectedPlayer, ranksInfos[i].rank)
                        end
                    end)
                end
            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("vehicle")), true, true, true, function()
                shouldStayOpened = true
                statsSeparator()
                RageUI.Separator("↓ ~g~Apparition ~s~↓")
                RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Spawn un véhicule", nil, { RightLabel = "→→" }, true, function(Hovered, Active, Selected)
                    if Selected then
                        local veh = CustomString()
                        if veh ~= nil then
                            local model = GetHashKey(veh)
                            if IsModelValid(model) then
                                RequestModel(model)
                                while not HasModelLoaded(model) do
                                    Wait(1)
                                end
                                TriggerServerEvent("adminmenu:spawnVehicle", model)
                            else
                                msg("Ce modèle n'existe pas")
                            end
                        end
                    end
                end)
                RageUI.Separator("↓ ~y~Gestion ~s~↓")
                RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Supprimer le véhicule", nil, { RightLabel = "→→" }, true, function(Hovered, Active, Selected)
                    if Active then
                        ClosetVehWithDisplay()
                    end
                    if Selected then
                        Citizen.CreateThread(function()
                            local veh = GetClosestVehicle(GetEntityCoords(GetPlayerPed(-1)), nil)
                            NetworkRequestControlOfEntity(veh)
                            while not NetworkHasControlOfEntity(veh) do
                                Wait(1)
                            end
                            DeleteEntity(veh)
                            ESX.ShowNotification("~g~Véhicule supprimé")
                        end)
                    end
                end)
                RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Réparer le véhicule", nil, { RightLabel = "→→" }, true, function(Hovered, Active, Selected)
                    if Active then
                        ClosetVehWithDisplay()
                    end
                    if Selected then
                        local veh = GetClosestVehicle(GetEntityCoords(GetPlayerPed(-1)), nil)
                        NetworkRequestControlOfEntity(veh)
                        while not NetworkHasControlOfEntity(veh) do
                            Wait(1)
                        end
                        SetVehicleFixed(veh)
                        SetVehicleDeformationFixed(veh)
                        SetVehicleDirtLevel(veh, 0.0)
                        SetVehicleEngineHealth(veh, 1000.0)
                        ESX.ShowNotification("~g~Véhicule réparé")
                    end
                end)

                RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Mettre un véhicule au garage", nil, { RightLabel = "→→" }, canUse("wipe", permLevel), function(Hovered, Active, Selected)
                    if Selected then
                        local plaque = CustomString()
                        if plaque ~= nil then
                        ESX.ShowNotification("~y~Mise en place du véhicule au garage si la plaque existe...")
                        TriggerServerEvent("adminmenu:mettregarage", plaque)
                        else
                        ESX.ShowNotification("~g~Plaque invalide...")
                        end
                    end
                end)

                RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Supprime les clés temporaires (Reboot)", nil, { RightLabel = "→→" }, canUse("wipe", permLevel), function(Hovered, Active, Selected)
                    if Selected then
                        local letsgo = CustomString()
                        if letsgo ~= nil then
                        ESX.ShowNotification("~y~Je supprime les clés temporaires...")
                        TriggerServerEvent("adminmenu:rmtempkeys", plaque)
                        else
                        ESX.ShowNotification("~r~Pas de confirmation je ne fait rien...")
                        end
                    end
                end)

            end, function()
            end, 1)

            if not shouldStayOpened and menuOpen then
                menuOpen = false
                RMenu:Delete(RMenu:Get(cat, subCat("main")))
                RMenu:Delete(RMenu:Get(cat, subCat("players")))
                RMenu:Delete(RMenu:Get(cat, subCat("reports")))
                RMenu:Delete(RMenu:Get(cat, subCat("reports_take")))
                RMenu:Delete(RMenu:Get(cat, subCat("vehicle")))
                RMenu:Delete(RMenu:Get(cat, subCat("setGroup")))
                RMenu:Delete(RMenu:Get(cat, subCat("items")))
                RMenu:Delete(RMenu:Get(cat, subCat("playersManage")))
            end
            Wait(0)
        end
    end)
end







