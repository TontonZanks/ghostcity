ESX = nil
local hasCinematic = false
local WindowsAll = 0
local Window1 = 1
local Window2 = 1
local Window3 = 1
local Window4 = 1
local Windows1 = 1
local Windows2 = 1


menu = {
  billing = {},
}

local cadeau

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerData = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
     PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)  
	PlayerData.job = job  
	Citizen.Wait(5000) 
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
    ESX.PlayerData.job2 = job2
    Citizen.Wait(2000)
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job2 == nil do
		Citizen.Wait(10)
    end

    if ESX.IsPlayerLoaded() then

		ESX.PlayerData = ESX.GetPlayerData()

    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
    ESX.PlayerData.job2 = job2
end)

RegisterNetEvent('es:activateMoney')
AddEventHandler('es:activateMoney', function(money)
	  ESX.PlayerData.money = money
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
	for i=1, #ESX.PlayerData.accounts, 1 do
		if ESX.PlayerData.accounts[i].name == account.name then
			ESX.PlayerData.accounts[i] = account
			break
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		SetDiscordAppId(916728250473000990)
		SetDiscordRichPresenceAsset('img')
    SetDiscordRichPresenceAssetText('Street Kings Roleplay')
    SetDiscordRichPresenceAssetSmall('img')
    SetDiscordRichPresenceAssetSmallText('https://discord.gg/FNugeNzQn2')
		Citizen.Wait(60000)
	end
end)






function Menuf5aldox()
    local faldoxf6 = RageUI.CreateMenu("Street Kings", "Interactions")
    faldoxf6:SetRectangleBanner(0, 0, 0)
    RageUI.Visible(faldoxf6, not RageUI.Visible(faldoxf6))
    while faldoxf6 do
        Citizen.Wait(0)
            RageUI.IsVisible(faldoxf6, true, true, true, function()
              
              RageUI.Separator("↓ Inventaire ↓")
              RageUI.ButtonWithStyle("Inventaire",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
                    if Selected then       
                        AldoxObjet()
                    end
                end)

              RageUI.ButtonWithStyle("Carte Sim",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
                  if Selected then
                    RageUI.CloseAll()
 			              TriggerEvent('esx_cartesim:OpenSim')                            
                  end
              end)

              RageUI.ButtonWithStyle("Portefeuille",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
                if Selected then       
                    PorteFeuilleAldox()
                end
              end)

              RageUI.ButtonWithStyle("Factures",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    AldoxFactures()    
                end
              end)

  --            RageUI.ButtonWithStyle("~p~Interactions Noel~w~",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
  --              if Selected then
  --                  AldoxNoel()    
  --              end
  --            end)

   --           RageUI.Separator("↓ Vêtements ↓")
              RageUI.ButtonWithStyle("Vêtements",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
                if Selected then       
                    VetementsAldox()
                end
              end)

   --           RageUI.ButtonWithStyle("Animations",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
   --             if Selected then       
   --                 AldoxAnimations()
   --             end
   --           end)

              if IsPedSittingInAnyVehicle(PlayerPedId()) then
              RageUI.ButtonWithStyle("Véhicules",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
                if Selected then       
                    AldoxVoitures()
                end
              end)
              end

              RageUI.Separator("↓ Clés ↓")
              RageUI.ButtonWithStyle("Clés de voiture",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
                if Selected then
                  RageUI.CloseAll()
                  TriggerEvent("esx_menu:key")
                end
              end)
              RageUI.ButtonWithStyle("Clés de maison",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    RageUI.CloseAll()       
                    ExecuteCommand("keys")
                end
              end)
              RageUI.Separator("↓ Divers ↓")
              RageUI.ButtonWithStyle("Divers",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
                if Selected then       
                    AldoxDivers()
                end
              end)
             



              end, function() 
              end)
    
                if not RageUI.Visible(faldoxf6) then
                    faldoxf6 = RMenu:DeleteType("Street Kings", true)
        end
    end
end

-- INVENTAIRE DU JOUEUR
local PlayersItem = {}
function AldoxObjet()
    local StockMenuAldox = RageUI.CreateMenu("Inventaire", "Inventaire")
    StockMenuAldox:SetRectangleBanner(0, 0, 0)
    ESX.TriggerServerCallback('AldoxObjet:getPlayerInventory', function(inventory)
        RageUI.Visible(StockMenuAldox, not RageUI.Visible(StockMenuAldox))
    while StockMenuAldox do
        Citizen.Wait(0)
            RageUI.IsVisible(StockMenuAldox, true, true, true, function()
                for i=1, #inventory.items, 1 do
                    if inventory ~= nil then
                         local item = inventory.items[i]
                            if item.count > 0 then
                                        RageUI.ButtonWithStyle(item.label, nil, {RightLabel = item.count}, true, function(Hovered, Active, Selected)
                                            if Selected then
                                                AldoxObjet2(item)
                                            end
                                    end)
                                end
                            else
                                RageUI.Separator('Chargement en cours')
                            end
                        end
                    end, function()
                    end)
                if not RageUI.Visible(StockMenuAldox) then
                StockMenuAldox = RMenu:DeleteType("Coffre", true)
                Menuf5aldox()
            end
        end
    end)
end

-- MENU DIVERS
function AldoxDivers()
  local DiversMenuAldox = RageUI.CreateMenu("Divers", "Divers")
  DiversMenuAldox:SetRectangleBanner(0, 0, 0)
  RageUI.Visible(DiversMenuAldox, not RageUI.Visible(DiversMenuAldox))
    while DiversMenuAldox do
      Citizen.Wait(0)
            RageUI.IsVisible(DiversMenuAldox, true, true, true, function()
            RageUI.ButtonWithStyle("Discord",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
                if Selected then
                        
                  ESX.ShowNotification("~b~Bienvenue sur Street Kings pour rejoindre le discord : ~r~https://discord.gg/FNugeNzQn2~w~")
                end
            end)

            RageUI.ButtonWithStyle("Filtres",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
              if Selected then
                  AldoxFiltres()
              end
          end)

          RageUI.ButtonWithStyle("Report",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected) 
            if (Selected) then 
                local report = KeyboardInputMenu("Quantité ?", " ", " ", 200)
                ExecuteCommand("report " ..report)
            end 
          end)

          RageUI.ButtonWithStyle("Retirer un Gilet Tactique", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
            if (Selected) then
                local armure = GetPedArmour(PlayerPedId())
                local player = GetPlayerPed(-1)
                if armure > 95.0 then
                    ExecuteCommand("me retire son gilet tactique")
                    SetPedArmour(player, 0.0)
                    TriggerServerEvent('aldox:Retiregilet')
                else
                    ExecuteCommand("me tente de retirer son gilet tactique, mais il est trop endommager")
                end

            end                        
        end)
              
          end, function()
          end)
              if not RageUI.Visible(DiversMenuAldox) then
              DiversMenuAldox = RMenu:DeleteType("Divers", true)
              
          end
      end
end

-- MENU Noel
function AldoxNoel()
  local NoelMenuAldox = RageUI.CreateMenu("~r~Menu Noel", "Choix")
  NoelMenuAldox:SetRectangleBanner(0, 0, 0)
  RageUI.Visible(NoelMenuAldox, not RageUI.Visible(NoelMenuAldox))
    while NoelMenuAldox do
      Citizen.Wait(0)
            RageUI.IsVisible(NoelMenuAldox, true, true, true, function()
            
              RageUI.ButtonWithStyle("~p~Ramasser des boules de neige",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected) 
                if (Selected) then 
                    RamasserBoulesNeige()
                end 
              end)

              RageUI.ButtonWithStyle("~b~Mettre son bonnet de Noel",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected) 
                if (Selected) then 
                    RequestAnimDict('missheist_agency2ahelmet')
                    TaskPlayAnim(PlayerPedId(), 'missheist_agency2ahelmet', 'take_off_helmet_stand', 8.0, -1, -1, 0, 0, 0, 0, 0)
                    Wait(1500)
                    changeBonnet() -- appel de la fonction
                end 
              end)

              RageUI.ButtonWithStyle("~r~Enlever son bonnet de Noel",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected) 
                if (Selected) then 
                    RequestAnimDict('missheist_agency2ahelmet')
                    TaskPlayAnim(PlayerPedId(), 'missheist_agency2ahelmet', 'take_off_helmet_stand', 8.0, -1, -1, 0, 0, 0, 0, 0)
                    Wait(1500)
                    removeBonnet()
                end 
              end)

              RageUI.ButtonWithStyle("~g~Donner un Cadeau",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected) 
                if (Selected) then
                    RequestAnimDict('anim@heists@box_carry@') 
                    ExecuteCommand("e box") -- à activer si vous avez le dpemotes, vous aurez la boite dans les mains.
                    TaskPlayAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 8.0, -1, -1, 0, 0, 0, 0, 0)
                end 
              end)

              RageUI.ButtonWithStyle("~g~Donner une Rose",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected) 
                if (Selected) then 
                    RequestAnimDict('anim@heists@humane_labs@finale@keycards')
                    ExecuteCommand("e rose") -- à activer si vous avez le dpemotes, vous aurez la rose dans les mains
                    TaskPlayAnim(PlayerPedId(), 'anim@heists@humane_labs@finale@keycards', 'ped_a_enter_loop', 8.0, -1, -1, 0, 0, 0, 0, 0) -- à désactiver si vous avez le dpemotes
                end 
              end)

              RageUI.ButtonWithStyle("~b~Mettre Couleur Amplifiées (Pour la neige)",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected) 
                if (Selected) then 
                    DoScreenFadeIn(2000)
                    DoScreenFadeOut(2000) 
                    LoadingPrompt("Changement de couleur en cours...", 3)
                    Citizen.Wait(2000)
                    DoScreenFadeIn(2000)
                    RemoveLoadingPrompt()
                    SetTimecycleModifier('rply_saturation')
                    RageUI.Popup({message = "Changement de couleur terminé ✅ !"})
                end 
              end)

              RageUI.ButtonWithStyle("~r~Enlever Couleur Amplifiées",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected) 
                if (Selected) then 
                    DoScreenFadeIn(2000)
                    DoScreenFadeOut(2000) 
                    LoadingPrompt("Changement de couleur en cours...", 3)
                    Citizen.Wait(2000)
                    DoScreenFadeIn(2000)
                    RemoveLoadingPrompt()
                    SetTimecycleModifier('')
                    RageUI.Popup({message = "Changement de couleur terminé ✅ !"})
                end 
              end)
              
          end, function()
          end)
              if not RageUI.Visible(NoelMenuAldox) then
              NoelMenuAldox = RMenu:DeleteType("Menu Noel", true)
              
          end
      end
end

-----
-- INTERACTIONS SAPIN 
--[[
Citizen.CreateThread(function()
	TimerInter = 500
	while true do
		
		local plycrdinter = GetEntityCoords(GetPlayerPed(-1), false)
		local distsapin = Vdist(plycrdinter.x, plycrdinter.y, plycrdinter.z, 181.559, -967.518, 30.09)
		if distsapin <= 1.5 then
			TimerInter = 0
				RageUI.Text({ message = "Appuyez sur ~b~[E]~s~ pour intéragir", time_display = 1 })
				if IsControlJustPressed(1,51) then
					AldoxSapin()
				end   
	end
	Citizen.Wait(TimerInter)   
	end
end) ]]
-- MENU Sapin
function AldoxSapin()
  local sapinMenuAldox = RageUI.CreateMenu("~r~Menu Cadeau", "Choix")
  AldoxCheckCadeau()
  sapinMenuAldox:SetRectangleBanner(0, 0, 0)
  RageUI.Visible(sapinMenuAldox, not RageUI.Visible(sapinMenuAldox))
    while sapinMenuAldox do
      Citizen.Wait(0)
            RageUI.IsVisible(sapinMenuAldox, true, true, true, function()
              if cadeau == false then
              RageUI.ButtonWithStyle("~b~Prendre mon cadeau du jour",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected) 
                if (Selected) then 
                    ExecuteCommand("e warmth")
                    Citizen.Wait(3000)
                    ClearPedTasks(GetPlayerPed(-1))
                    TriggerServerEvent("aldox:clearcadeau")
                    Citizen.Wait(200)
                    AldoxCheckCadeau()
                end 
              end)
              else
                RageUI.ButtonWithStyle("~r~Merci de revenir demain pour un nouveau cadeau",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected) 
                  if (Selected) then 
                     
                  end 
                end)
              end


          end, function()
          end)
              if not RageUI.Visible(sapinMenuAldox) then
              sapinMenuAldox = RMenu:DeleteType("Menu Cadeau", true)
              
          end
      end
end

function AldoxCheckCadeau()
  ESX.TriggerServerCallback('aldox:statuscadeau', function(cadwonoel)
    if cadwonoel == 0 then
      cadeau = false
    else
      cadeau = true
    end
  end)
end
-----
function removeBonnet(model)
  clothesSkin = {}

  if model == GetHashKey("mp_m_freemode_01") then
      clothesSkin = {
          ['helmet_1'] = -1, ['helmet_2'] =  0,
      }
  else
    clothesSkin = {
        ['helmet_1'] = -1, ['helmet_2'] =  0,
   }
  end

  for k,v in pairs(clothesSkin) do
      TriggerEvent("skinchanger:change", k, v)
 end
end

function changeBonnet(model)
  clothesSkin = {}

  if model == GetHashKey("mp_m_freemode_01") then
      clothesSkin = {
          ['helmet_1'] = 22, ['helmet_2'] =  0,
      }
  else
      clothesSkin = {
        ['helmet_1'] = 23, ['helmet_2'] =  0,
    }
  end

  for k,v in pairs(clothesSkin) do
      TriggerEvent("skinchanger:change", k, v)
 end
end
function RamasserBoulesNeige()
  local snowballs = math.random(1,3)
  RequestAnimDict('anim@mp_snowball')
  TaskPlayAnim(PlayerPedId(), 'anim@mp_snowball', 'pickup_snowball', 8.0, -1, -1, 0, 0, 0, 0, 0)
  FreezeEntityPosition(PlayerPedId(), true)
  Citizen.Wait(2000)
  FreezeEntityPosition(PlayerPedId(), false)
  GiveWeaponToPed(PlayerPedId(), GetHashKey('WEAPON_SNOWBALL'), snowballs, false, true)
  ESX.ShowNotification("~r~Noel : ~b~Vous avez ramasser ~y~\n" .. snowballs .. " ~b~Boules de neige")
end





-- MENU PORTEFEUILLE
function PorteFeuilleAldox()
  local PortefeuilleMenuAldox = RageUI.CreateMenu("Portefeuille", "Portefeuille")
  PortefeuilleMenuAldox:SetRectangleBanner(0, 0, 0)
  RageUI.Visible(PortefeuilleMenuAldox, not RageUI.Visible(PortefeuilleMenuAldox))
    while PortefeuilleMenuAldox do
      Citizen.Wait(0)
          RageUI.IsVisible(PortefeuilleMenuAldox, true, true, true, function()
          RageUI.ButtonWithStyle("~b~Métier 1 : ",nil, {RightLabel = ESX.PlayerData.job.label .. " | ~b~" .. ESX.PlayerData.job.grade_label}, true, function(Hovered, Active, Selected)
                if Selected then
                
                end
          end)

          RageUI.ButtonWithStyle("~r~Métier 2 : ",nil, {RightLabel = ESX.PlayerData.job2.label .. " | ~r~" ..  ESX.PlayerData.job2.grade_label}, true, function(Hovered, Active, Selected)
              if Selected then
              
              end
          end)

          RageUI.ButtonWithStyle("Argent Liquide : ",nil, {RightLabel = "[ ~g~"..ESX.Math.GroupDigits(ESX.PlayerData.money.. "$~w~ ]" .. "~s~~b~ →")}, true, function(Hovered, Active, Selected)
            if Selected then
              local propremoney, quantityargentpropre = CheckQuantityMenu(KeyboardInputMenu("Quantité ?", " ", " ", 8))
                if propremoney then
                  local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                  if closestDistance ~= -1 and closestDistance <= 3 then
                    local closestPed = GetPlayerPed(closestPlayer)

                    if not IsPedSittingInAnyVehicle(closestPed) then
                      TriggerServerEvent('esx:gialdoxveInventoryItem', GetPlayerServerId(closestPlayer), 'item_money', ESX.PlayerData.money, quantityargentpropre)
                    else
                      ESX.ShowNotification('∑ Vous ne pouvez pas donner ', 'de  ~r~l\'argent ~s~ dans un véhicule')
                    end
                  else
                    ESX.ShowNotification('∑ Aucun joueur  ~r~proche ~s~ !')
                  end
                  else
                ESX.ShowNotification('∑ Somme ~r~incorrecte !')
              end
            end
        end)

        for i = 1, #ESX.PlayerData.accounts, 1 do
          if ESX.PlayerData.accounts[i].name == 'black_money'  then
          RageUI.ButtonWithStyle("Argent Sale : ",nil, {RightLabel = "~w~[ ~r~"..ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money.. "$~w~ ]".."~s~~b~ →")}, true, function(Hovered, Active, Selected)
          if Selected then
            local blackmoney, quantityargentsale = CheckQuantityMenu(KeyboardInputMenu("Quantité ?", " ", " ", 8))
                if blackmoney then
                  local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                  if closestDistance ~= -1 and closestDistance <= 3 then
                    local closestPed = GetPlayerPed(closestPlayer)

                    if not IsPedSittingInAnyVehicle(closestPed) then
                      TriggerServerEvent('esx:gialdoxveInventoryItem', GetPlayerServerId(closestPlayer), 'item_account', ESX.PlayerData.accounts[i].name, quantityargentsale)
                    else
                      ESX.ShowNotification('∑ Vous ne pouvez pas donner ', 'de  ~r~l\'argent ~s~ dans un véhicule')
                    end
                  else
                    ESX.ShowNotification('∑ Aucun joueur  ~r~proche ~s~ !')
                  end
                  else
                ESX.ShowNotification('∑ Somme ~r~incorrecte !')
              end
            end
        
        end)
      end
      end

        RageUI.ButtonWithStyle("~b~Regarder sa carte d'identité ",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
          if Selected then
            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
          end
        end)

        RageUI.ButtonWithStyle("~y~Montrer sa carte d'identité ",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
          if Selected then
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                        
            if closestDistance ~= -1 and closestDistance <= 3.0 then
              TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer))
            else
              ESX.ShowNotification(('Aucun joueur à proximité'))
            end
          
          end
        end)

        --

        RageUI.ButtonWithStyle("~b~Regarder son permis de conduire ",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
          if Selected then
            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')
          end
        end)

        RageUI.ButtonWithStyle("~y~Montrer son permis de conduire ",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
          if Selected then
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                        
            if closestDistance ~= -1 and closestDistance <= 3.0 then
                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'driver')
            else
                ESX.ShowNotification(('Aucun joueur à proximité'))
            end
          
          end
        end)

        --

        RageUI.ButtonWithStyle("~b~Regarder son permis de port d'armes ",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
          if Selected then
            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'weapon')
          end
        end)

        RageUI.ButtonWithStyle("~y~Montrer son permis de port d'armes ",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
          if Selected then
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                        
            if closestDistance ~= -1 and closestDistance <= 3.0 then
                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'weapon')
            else
                ESX.ShowNotification(('Aucun joueur à proximité'))
            end
          
          end
        end)
              
          end, function()
          end)
              if not RageUI.Visible(PortefeuilleMenuAldox) then
              PortefeuilleMenuAldox = RMenu:DeleteType("Portefeuille", true)
              Menuf5aldox()
          end
      end
end

-- MENU Vêtements
function VetementsAldox()
  local vetementsMenuAldox = RageUI.CreateMenu("Vêtements", "Vêtements")
  vetementsMenuAldox:SetRectangleBanner(0, 0, 0)
  RageUI.Visible(vetementsMenuAldox, not RageUI.Visible(vetementsMenuAldox))
    while vetementsMenuAldox do
      Citizen.Wait(0)
            RageUI.IsVisible(vetementsMenuAldox, true, true, true, function()
              RageUI.ButtonWithStyle("Veste",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerEvent('changerhaut')
                end
              end)
          RageUI.ButtonWithStyle("Pantalon",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerEvent('changerpantalon')    
                end
              end)
          RageUI.ButtonWithStyle("Chaussures",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
              if Selected then
                  TriggerEvent('changerchaussure')
              end
          end)
          RageUI.ButtonWithStyle("Sac",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
            if Selected then
                  TriggerEvent('changersac')
            end
          end)
          RageUI.ButtonWithStyle("Gilet par-balle",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
          if Selected then
              TriggerEvent('changergpb')  
          end
          end)

          RageUI.ButtonWithStyle("Masque",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
            if Selected then
                SetUnsetAccessory('Mask') 
            end
          end)

          RageUI.ButtonWithStyle("Lunettes",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
            if Selected then
                SetUnsetAccessory('Glasses') 
            end
          end)

          RageUI.ButtonWithStyle("Chapeau",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
            if Selected then
                SetUnsetAccessory('Helmet') 
            end
          end)
              
          end, function()
          end)
              if not RageUI.Visible(vetementsMenuAldox) then
              vetementsMenuAldox = RMenu:DeleteType("Vêtements", true)
              Menuf5aldox()
          end
      end
end

-- MENU Animations
function AldoxAnimations()
  local AnimationsMenuAldox = RageUI.CreateMenu("Animations", "Animations")
  AnimationsMenuAldox:SetRectangleBanner(0, 0, 0)
  RageUI.Visible(AnimationsMenuAldox, not RageUI.Visible(AnimationsMenuAldox))
    while AnimationsMenuAldox do
      Citizen.Wait(0)
            RageUI.IsVisible(AnimationsMenuAldox, true, true, true, function()
            RageUI.ButtonWithStyle("Festives",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
                if Selected then
                  AldoxFestives()                        
                end
            end)

            RageUI.ButtonWithStyle("Salutations",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
              if Selected then
                  
              end
            end)

            RageUI.ButtonWithStyle("Travail",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
              if Selected then
                  
              end
            end)

            RageUI.ButtonWithStyle("Humeur",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
              if Selected then
                  
              end
            end)

            RageUI.ButtonWithStyle("Sports",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
              if Selected then
                  
              end
            end)

            RageUI.ButtonWithStyle("Divers",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
              if Selected then
                  
              end
            end)

            RageUI.ButtonWithStyle("PEGI 21",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
              if Selected then
                  
              end
            end)

            





              
          end, function()
          end)
              if not RageUI.Visible(AnimationsMenuAldox) then
              AnimationsMenuAldox = RMenu:DeleteType("Animations", true)
                      
          end
      end
end

-- MENU FESTIVE
function AldoxFestives()
  local FestivesMenuAldox = RageUI.CreateMenu("Festives", "Festives")
  FestivesMenuAldox:SetRectangleBanner(0, 0, 0)
  RageUI.Visible(FestivesMenuAldox, not RageUI.Visible(FestivesMenuAldox))
    while FestivesMenuAldox do
      Citizen.Wait(0)
            RageUI.IsVisible(FestivesMenuAldox, true, true, true, function()
            RageUI.ButtonWithStyle("Fumer une cigarette",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
                if Selected then
                  ExecuteCommand("e smoke")                       
                end
            end)


                  
          end, function()
          end)
              if not RageUI.Visible(FestivesMenuAldox) then
              FestivesMenuAldox = RMenu:DeleteType("Festives", true)
              AldoxFestive()        
          end
      end
end

-- MENU VOITURES
function AldoxVoitures()
  local VoituresMenuAldox = RageUI.CreateMenu("Véhicules", "Véhicules")
  VoituresMenuAldox:SetRectangleBanner(0, 0, 0)
  RageUI.Visible(VoituresMenuAldox, not RageUI.Visible(VoituresMenuAldox))
  local voiturealdoxlive = GetVehiclePedIsIn(GetPlayerPed(-1), false)
  local aldoxcarproperty = ESX.Game.GetVehicleProperties(voiturealdoxlive)
  local boat = GetEntityModel(voiturealdoxlive)
  print(aldoxcarproperty)
    while VoituresMenuAldox do
      Citizen.Wait(0)
            RageUI.IsVisible(VoituresMenuAldox, true, true, true, function()

            RageUI.ButtonWithStyle("Radio du véhicule",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    RageUI.CloseAll()
                    ExecuteCommand("carradio")                 
                end
            end)
            if IsThisModelABoat(boat) then
            RageUI.ButtonWithStyle("Jeter l'encre",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
              if Selected then
                  RageUI.CloseAll()
                  FreezeEntityPosition(voiturealdoxlive, true)                 
              end
            end)

            RageUI.ButtonWithStyle("Remonter l'encre",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
              if Selected then
                  RageUI.CloseAll()
                  FreezeEntityPosition(voiturealdoxlive, false)                 
              end
            end)
            end

            RageUI.ButtonWithStyle("Ouvrir / Fermer le Capot",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    ExecuteCommand("hood")                 
                end
            end)

            RageUI.ButtonWithStyle("Ouvrir / Fermer le Coffre",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
              if Selected then
                  ExecuteCommand("trunk")          
              end
            end)

            RageUI.ButtonWithStyle("Ouvrir / Fermer les Portes",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
              if Selected then
                  ExecuteCommand("rdoors")          
              end
            end)

            RageUI.ButtonWithStyle("Ouvrir / Fermer les Vitres",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
              if Selected then
                local playerPed = GetPlayerPed(-1)
                local playerVeh = GetVehiclePedIsIn(playerPed, false)
                if ( IsPedSittingInAnyVehicle( playerPed ) ) and WindowsAll == 0 then
                  RollUpWindow(playerVeh, 0)
                  RollUpWindow(playerVeh, 1)
                  RollUpWindow(playerVeh, 2)
                  RollUpWindow(playerVeh, 3)
                  WindowsAll = 1
                else
                    RollDownWindow(playerVeh, 0)
                    RollDownWindow(playerVeh, 1)
                    RollDownWindow(playerVeh, 2)
                    RollDownWindow(playerVeh, 3)
                    WindowsAll = 0
                end          
              end
            end)
            
            local moteurveh = math.floor(GetVehicleEngineHealth(GetVehiclePedIsIn(GetPlayerPed(-1), false)) / 10,2)
            local carosserieVeh = math.floor(GetVehicleBodyHealth(GetVehiclePedIsIn(GetPlayerPed(-1), false)) / 10,2)
            local etat = (moteurveh + carosserieVeh) /2
    
           
            

            RageUI.ButtonWithStyle("Plaque du Véhicule",nil, {RightLabel = " [ ~y~" .. GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false)) .. "~w~ ]" }, true, function(Hovered, Active, Selected)
              if Selected then          
              end
            end)

            if moteurveh > 40 then
            RageUI.ButtonWithStyle("Etat du Moteur",nil, {RightLabel = " [ ~b~" .. moteurveh .. "~w~ ]" }, true, function(Hovered, Active, Selected)
              if Selected then          
              end
            end)
            else
            RageUI.ButtonWithStyle("Etat du Moteur",nil, {RightLabel = " [ ~r~" .. moteurveh .. "~w~ ]" }, true, function(Hovered, Active, Selected)
                if Selected then          
                end
            end)
            end

          if carosserieVeh > 40 then
            RageUI.ButtonWithStyle("Etat de la Carosserie",nil, {RightLabel = " [ ~b~" .. carosserieVeh .. "~w~ ]" }, true, function(Hovered, Active, Selected)
              if Selected then          
              end
            end)
          else
            RageUI.ButtonWithStyle("Etat de la Carosserie",nil, {RightLabel = " [ ~r~" .. carosserieVeh .. "~w~ ]" }, true, function(Hovered, Active, Selected)
                if Selected then          
                end
            end)
          end
          if aldoxcarproperty.modTurbo then
            RageUI.ButtonWithStyle("Turbo",nil, {RightLabel = " [ ~g~" .. "Oui" .. "~w~ ]" }, true, function(Hovered, Active, Selected)
              if Selected then          
              end
            end)
          else
            RageUI.ButtonWithStyle("Turbo",nil, {RightLabel = " [ ~r~" .. "Non" .. "~w~ ]" }, true, function(Hovered, Active, Selected)
              if Selected then          
              end
            end)
          end
          if aldoxcarproperty.modEngine > 0 then
          RageUI.ButtonWithStyle("Niveau Moteur",nil, {RightLabel = " [ ~g~" .. aldoxcarproperty.modEngine .. "~w~ ]" }, true, function(Hovered, Active, Selected)
            if Selected then          
            end
          end)
          else
          RageUI.ButtonWithStyle("Niveau Moteur",nil, {RightLabel = " [ ~r~" .. aldoxcarproperty.modEngine .. "~w~ ]" }, true, function(Hovered, Active, Selected)
              if Selected then          
              end
          end)
        end
        if aldoxcarproperty.modTransmission > 0 then
          RageUI.ButtonWithStyle("Niveau Transmission",nil, {RightLabel = " [ ~g~" .. aldoxcarproperty.modTransmission .. "~w~ ]" }, true, function(Hovered, Active, Selected)
            if Selected then          
            end
          end)
        else
          RageUI.ButtonWithStyle("Niveau Transmission",nil, {RightLabel = " [ ~r~" .. aldoxcarproperty.modTransmission .. "~w~ ]" }, true, function(Hovered, Active, Selected)
            if Selected then          
            end
          end)
        end
        if aldoxcarproperty.modArmor > 0 then
          RageUI.ButtonWithStyle("Niveau Blindage",nil, {RightLabel = " [ ~g~" .. aldoxcarproperty.modArmor .. "~w~ ]" }, true, function(Hovered, Active, Selected)
            if Selected then          
            end
          end)
        else
          RageUI.ButtonWithStyle("Niveau Blindage",nil, {RightLabel = " [ ~r~" .. aldoxcarproperty.modArmor .. "~w~ ]" }, true, function(Hovered, Active, Selected)
            if Selected then          
            end
          end)
        end
        if aldoxcarproperty.modSuspension > 0 then
          RageUI.ButtonWithStyle("Niveau Suspension",nil, {RightLabel = " [ ~g~" .. aldoxcarproperty.modSuspension .. "~w~ ]" }, true, function(Hovered, Active, Selected)
            if Selected then          
            end
          end)
        else
          RageUI.ButtonWithStyle("Niveau Suspension",nil, {RightLabel = " [ ~r~" .. aldoxcarproperty.modSuspension .. "~w~ ]" }, true, function(Hovered, Active, Selected)
            if Selected then          
            end
          end)
        end
        if aldoxcarproperty.modBrakes > 0 then
          RageUI.ButtonWithStyle("Niveau des Freins",nil, {RightLabel = " [ ~g~" .. aldoxcarproperty.modBrakes .. "~w~ ]" }, true, function(Hovered, Active, Selected)
            if Selected then          
            end
          end)
        else
          RageUI.ButtonWithStyle("Niveau des Freins",nil, {RightLabel = " [ ~r~" .. aldoxcarproperty.modBrakes .. "~w~ ]" }, true, function(Hovered, Active, Selected)
            if Selected then          
            end
          end)
        end



                  
          end, function()
          end)
              if not RageUI.Visible(VoituresMenuAldox) then
              VoituresMenuAldox = RMenu:DeleteType("Véhicules", true)      
          end
      end
end



-- MENU FACTURE
function AldoxFactures()
  local FacturesMenuAldox = RageUI.CreateMenu("Factures", "Factures")
  FacturesMenuAldox:SetRectangleBanner(0, 0, 0)
  RageUI.Visible(FacturesMenuAldox, not RageUI.Visible(FacturesMenuAldox))
    while FacturesMenuAldox do
      Citizen.Wait(0)
            RageUI.IsVisible(FacturesMenuAldox, true, true, true, function()
              ESX.TriggerServerCallback('VInventory:billing', function(bills) menu.billing = bills end)

              if #menu.billing == 0 then
                  RageUI.ButtonWithStyle("Aucune facture", nil, { RightLabel = "" }, true, function(Hovered, Active, Selected)
                      if (Selected) then
                      end
                  end)
              end
                  
              for i = 1, #menu.billing, 1 do
              RageUI.ButtonWithStyle(menu.billing[i].label, nil, {RightLabel = '[~b~$' .. ESX.Math.GroupDigits(menu.billing[i].amount.."~s~] →")}, true, function(Hovered,Active,Selected)
                  if Selected then
                    local value = menu.billing[i].id
                    ESX.TriggerServerCallback('esx_billing:payBill', function()
                    end, value)  
                  end
                end)
              end


                  
          end, function()
          end)
              if not RageUI.Visible(FacturesMenuAldox) then
              FacturesMenuAldox = RMenu:DeleteType("Factures", true)
              Menuf5aldox()        
          end
      end
end



-- MENU ACTIONS OBJETS
function AldoxObjet2(item)
  local Objet2MenuAldox = RageUI.CreateMenu("Actions", "Objet")
  Objet2MenuAldox:SetRectangleBanner(0, 0, 0)
  RageUI.Visible(Objet2MenuAldox, not RageUI.Visible(Objet2MenuAldox))
    while Objet2MenuAldox do
      Citizen.Wait(0)
            RageUI.IsVisible(Objet2MenuAldox, true, true, true, function()
            RageUI.ButtonWithStyle("Utiliser",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    if item.usable then
                      RageUI.CloseAll()
                      TriggerServerEvent('esx:useItem', item.name)
                      Citizen.Wait(300)
                      --AldoxObjet()
                      RageUI.CloseAll()
                    else
                      ESX.ShowNotification("~r~L'objet " .. item.label .. " n\'est pas un consommable")
                    end
                   
                end
            end)

            RageUI.ButtonWithStyle("Donner",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
              if Active then
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                local pPed = GetPlayerPed(-1)
                local coords = GetEntityCoords(closestPlayer)
                local x,y,z = table.unpack(coords)
                DrawMarker(2, x, y, z+1.5, 0, 0, 0, 180.0,nil,nil, 0.5, 0.5, 0.5, 0, 0, 255, 120, true, true, p19, true)
              end
              if (Selected) then
                  local sonner,quantity = CheckQuantityMenu(KeyboardInputMenu("Quantité ?", " ", " ", 6))

                  local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                  local pPed = GetPlayerPed(-1)
                  local coords = GetEntityCoords(closestPlayer)
                  local x,y,z = table.unpack(coords)
                  DrawMarker(2, x, y, z+1.5, 0, 0, 0, 180.0,nil,nil, 0.5, 0.5, 0.5, 0, 0, 255, 120, true, true, p19, true)

                  if sonner then
                      if closestDistance ~= -1 and closestDistance <= 3 then
                          local closestPed = GetPlayerPed(closestPlayer)

                          if IsPedOnFoot(closestPed) then
                                  RageUI.CloseAll()
                                  TriggerServerEvent('esx:gialdoxveInventoryItem', GetPlayerServerId(closestPlayer), 'item_standard', item.name, quantity)
                                  Citizen.Wait(300)
                                  AldoxObjet()
                          else
                                  ESX.ShowNotification("~r~Quantité non valide")
                          end
                      
                      else
                          ESX.ShowNotification("~r~Aucun joueur proche de vous")
                      end
                  end
              end
          end)

              
          end, function()
          end)
              if not RageUI.Visible(Objet2MenuAldox) then
              Objet2MenuAldox = RMenu:DeleteType("Actions", true)
          end
      end
end

-- MENU FILTRES
function AldoxFiltres()
  local FiltressMenuAldox = RageUI.CreateMenu("Filtres", "Filtres")
  FiltressMenuAldox:SetRectangleBanner(0, 0, 0)
  ESX.TriggerServerCallback('AldoxObjet:getPlayerInventory', function(inventory)
      RageUI.Visible(FiltressMenuAldox, not RageUI.Visible(FiltressMenuAldox))
  while FiltressMenuAldox do
      Citizen.Wait(0)
            RageUI.IsVisible(FiltressMenuAldox, true, true, true, function()
            RageUI.ButtonWithStyle("~r~Désactiver les Filtres~w~",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
                if Selected then       
                  SetTimecycleModifier('')
                end
            end)

            RageUI.ButtonWithStyle("~p~Activer le mode Dégat",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
              if Selected then
                SetTimecycleModifier('rply_vignette')
              end
            end)

            RageUI.ButtonWithStyle("~p~Activer le mode Vue lumineux",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
              if Selected then
                SetTimecycleModifier('rply_vignette_neg')
              end
            end)

            RageUI.ButtonWithStyle("~p~Activer le mode Couleurs amplifiées",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
              if Selected then
                SetTimecycleModifier('rply_saturation')
              end
            end)

            RageUI.ButtonWithStyle("~p~Activer le mode Noir & blancs",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
              if Selected then
                SetTimecycleModifier('rply_saturation_neg')
              end
            end)

            RageUI.ButtonWithStyle("~p~Activer le mode Vue & lumières améliorées",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
              if Selected then
                SetTimecycleModifier('tunnel')
              end
            end)

            RageUI.ButtonWithStyle("~p~Activer le mode Visual 1",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
              if Selected then
                SetTimecycleModifier('yell_tunnel_nodirect')
              end
            end)

            RageUI.ButtonWithStyle("~p~Activer le mode Blanc",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
              if Selected then
                SetTimecycleModifier('rply_contrast_neg')
              end
            end)

            RageUI.ButtonWithStyle("~b~Activer le Radar~w~",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
              if Selected then
                DisplayRadar(true)
              end
            end)

            RageUI.ButtonWithStyle("~r~Désactiver le Radar~w~",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
              if Selected then
                DisplayRadar(false)
              end
            end)

            RageUI.ButtonWithStyle("~b~Activer le mode Film~w~",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
              if Selected then                
                  SendNUIMessage({openCinema = true})
                  ESX.UI.HUD.SetDisplay(0.0)
                  TriggerEvent('esx_status:setDisplay', 0.0)
                  DisplayRadar(false)
              end
            end)

            RageUI.ButtonWithStyle("~r~Désactiver le mode Film~w~",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
              if Selected then                
                  SendNUIMessage({openCinema = false})
                  ESX.UI.HUD.SetDisplay(1.0)
                  TriggerEvent('esx_status:setDisplay', 1.0)
                  DisplayRadar(true)
              end
            end)

            RageUI.ButtonWithStyle("~b~Activer HUD~w~",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
              if Selected then                
                  TriggerEvent('esx_status:setDisplay', 1.0)
                  DisplayRadar(true)
              end
            end)

            RageUI.ButtonWithStyle("~r~Désactiver HUD~w~",nil, {RightLabel = "~b~→"}, true, function(Hovered, Active, Selected)
              if Selected then                
                  TriggerEvent('esx_status:setDisplay', 0.0)
                  DisplayRadar(false)
              end
            end)

                       
          end, function()
          end)
              if not RageUI.Visible(FiltressMenuAldox) then
              FiltressMenuAldox = RMenu:DeleteType("Filtres", true)
              
          end
      end
  end)
end
-- OUVERTURE DU MENU
Keys.Register('F5', 'AldoxMenu', 'Ouvrir le menu Général', function()
    	    Menuf5aldox()
end)

Keys.Register('F3', 'EmoteMenu', 'Ouvrir le menu des Emotes', function()
    ExecuteCommand("emotemenu")
end)



Citizen.CreateThread(function()
	while true do
		local TimerPause = 500
		if IsPauseMenuActive() then
			ESX.UI.HUD.SetDisplay(0.0)
		elseif hasCinematic == true then
			ESX.UI.HUD.SetDisplay(0.0)
		end
      Citizen.Wait(TimerPause)
	end
end)

function KeyboardInputMenu(entryTitle, textEntry, inputText, maxLength)
  AddTextEntry(entryTitle, textEntry)
  DisplayOnscreenKeyboard(1, entryTitle, '', inputText, '', '', '', maxLength)

  while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
    Citizen.Wait(0)
  end

  if UpdateOnscreenKeyboard() ~= 2 then
    local result = GetOnscreenKeyboardResult()
    Citizen.Wait(500)
    return result
  else
    Citizen.Wait(500)
    return nil
  end
end

function CheckQuantityMenu(number)
  number = tonumber(number)

  if type(number) == 'number' then
    number = ESX.Math.Round(number)

    if number > 0 then
      return true, number
    end
  end

  return false, number
end






-- Vétements

RegisterNetEvent('changerhaut')
AddEventHandler('changerhaut', function()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skina)
        TriggerEvent('skinchanger:getSkin', function(skinb)
            local lib, anim = 'clothingtie', 'try_tie_neutral_a'
            ESX.Streaming.RequestAnimDict(lib, function()
                TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
            end)
            Citizen.Wait(1000)
            ClearPedTasks(PlayerPedId())

            if skina.torso_1 ~= skinb.torso_1 then
                vethaut = true
                TriggerEvent('skinchanger:loadClothes', skinb, {['torso_1'] = skina.torso_1, ['torso_2'] = skina.torso_2, ['tshirt_1'] = skina.tshirt_1, ['tshirt_2'] = skina.tshirt_2, ['arms'] = skina.arms})
            else
                TriggerEvent('skinchanger:loadClothes', skinb, {['torso_1'] = 15, ['torso_2'] = 0, ['tshirt_1'] = 15, ['tshirt_2'] = 0, ['arms'] = 15})
                vethaut = false
            end
        end)
    end)
end)

RegisterNetEvent('changerpantalon')
AddEventHandler('changerpantalon', function()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skina)
        TriggerEvent('skinchanger:getSkin', function(skinb)
            local lib, anim = 'clothingtrousers', 'try_trousers_neutral_c'

            ESX.Streaming.RequestAnimDict(lib, function()
                TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
            end)
            Citizen.Wait(1000)
            ClearPedTasks(PlayerPedId())

            if skina.pants_1 ~= skinb.pants_1 then
                TriggerEvent('skinchanger:loadClothes', skinb, {['pants_1'] = skina.pants_1, ['pants_2'] = skina.pants_2})
                vetbas = true
            else
                vetbas = false
                if skina.sex == 1 then
                    TriggerEvent('skinchanger:loadClothes', skinb, {['pants_1'] = 15, ['pants_2'] = 0})
                else
                    TriggerEvent('skinchanger:loadClothes', skinb, {['pants_1'] = 61, ['pants_2'] = 1})
                end
            end
        end)
    end)
end)


RegisterNetEvent('changerchaussure')
AddEventHandler('changerchaussure', function()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skina)
        TriggerEvent('skinchanger:getSkin', function(skinb)
            local lib, anim = 'clothingshoes', 'try_shoes_positive_a'
            ESX.Streaming.RequestAnimDict(lib, function()
                TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
            end)
            Citizen.Wait(1000)
            ClearPedTasks(PlayerPedId())
            if skina.shoes_1 ~= skinb.shoes_1 then
                TriggerEvent('skinchanger:loadClothes', skinb, {['shoes_1'] = skina.shoes_1, ['shoes_2'] = skina.shoes_2})
                vetch = true
            else
                vetch = false
                if skina.sex == 1 then
                    TriggerEvent('skinchanger:loadClothes', skinb, {['shoes_1'] = 35, ['shoes_2'] = 0})
                else
                    TriggerEvent('skinchanger:loadClothes', skinb, {['shoes_1'] = 34, ['shoes_2'] = 0})
                end
            end
        end)
    end)
end)

RegisterNetEvent('changersac')
AddEventHandler('changersac', function()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skina)
        TriggerEvent('skinchanger:getSkin', function(skinb)
            local lib, anim = 'clothingtie', 'try_tie_neutral_a'
            ESX.Streaming.RequestAnimDict(lib, function()
                TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
            end)
            Citizen.Wait(1000)
            ClearPedTasks(PlayerPedId())
            if skina.bags_1 ~= skinb.bags_1 then
                TriggerEvent('skinchanger:loadClothes', skinb, {['bags_1'] = skina.bags_1, ['bags_2'] = skina.bags_2})
                vetsac = true
            else
                TriggerEvent('skinchanger:loadClothes', skinb, {['bags_1'] = 0, ['bags_2'] = 0})
                vetsac = false
            end
        end)
    end)
end)


RegisterNetEvent('changergpb')
AddEventHandler('changergpb', function()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skina)
        TriggerEvent('skinchanger:getSkin', function(skinb)
            local lib, anim = 'clothingtie', 'try_tie_neutral_a'
            ESX.Streaming.RequestAnimDict(lib, function()
                TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
            end)
            Citizen.Wait(1000)
            ClearPedTasks(PlayerPedId())
            if skina.bproof_1 ~= skinb.bproof_1 then
                TriggerEvent('skinchanger:loadClothes', skinb, {['bproof_1'] = skina.bproof_1, ['bproof_2'] = skina.bproof_2})
                vetgilet = true
            else
                TriggerEvent('skinchanger:loadClothes', skinb, {['bproof_1'] = 0, ['bproof_2'] = 0})
                vetgilet = false
            end
        end)
    end)
end)


function SetUnsetAccessory(accessory)
	ESX.TriggerServerCallback('esx_accessories:get', function(hasAccessory, accessorySkin)
		local _accessory = string.lower(accessory)

		if hasAccessory then
			TriggerEvent('skinchanger:getSkin', function(skin)
				local mAccessory = -1
				local mColor = 0

				if _accessory == 'ears' then
				elseif _accessory == "glasses" then
					mAccessory = 0
					local lib, anim = 'clothingtie', 'try_tie_neutral_a'
            ESX.Streaming.RequestAnimDict(lib, function()
                TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
            end)
					Citizen.Wait(850)
					ClearPedTasks(GetPlayerPed(-1))
				elseif _accessory == 'helmet' then
					local lib, anim = 'clothingtie', 'try_tie_neutral_a'
            ESX.Streaming.RequestAnimDict(lib, function()
                TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
            end)
          Citizen.Wait(850)
					ClearPedTasks(GetPlayerPed(-1))
				elseif _accessory == "mask" then
					mAccessory = 0
					local lib, anim = 'clothingtie', 'try_tie_neutral_a'
            ESX.Streaming.RequestAnimDict(lib, function()
                TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
            end)
					Citizen.Wait(850)
					ClearPedTasks(GetPlayerPed(-1))
				end

				if skin[_accessory .. '_1'] == mAccessory then
					mAccessory = accessorySkin[_accessory .. '_1']
					mColor = accessorySkin[_accessory .. '_2']
				end

				local accessorySkin = {}
				accessorySkin[_accessory .. '_1'] = mAccessory
				accessorySkin[_accessory .. '_2'] = mColor
				TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
			end)
		else
			if _accessory == 'ears' then
				ESX.ShowNotification("~r~Vous n'avez pas d'ascessoires")
			elseif _accessory == 'glasses' then
				ESX.ShowNotification("~r~Vous n'avez pas de Lunettes")
			elseif _accessory == 'helmet' then
				ESX.ShowNotification("~r~Vous n'avez pas de Chapeau")
			elseif _accessory == 'mask' then
				ESX.ShowNotification("~r~Vous n'avez pas de Masque")
			end
		end

	end, accessory)
end



--- ACCROUPI

local crouched = false
local GUI = {}
GUI.Time = 0

Citizen.CreateThread(function()
  while true do 
      Citizen.Wait(0)

      local plyPed = PlayerPedId()

      if DoesEntityExist(plyPed) and not IsEntityDead(plyPed) then 
          DisableControlAction(1, 36, true)

          if not IsPauseMenuActive() then 
              if IsDisabledControlJustPressed(1, 36) then 
                  RequestAnimSet("move_ped_crouched")

                  while not HasAnimSetLoaded("move_ped_crouched") do 
                      Citizen.Wait(100)
                  end 

                  if crouched == true then 
                      ResetPedMovementClipset(plyPed, 0)
                      crouched = false 
                  elseif crouched == false then
                      SetPedMovementClipset(plyPed, "move_ped_crouched", 0.25)
                      crouched = true 
                  end 
        
        GUI.Time = GetGameTimer()
              end
          end 
      end 
  end
end)


----- MAINS EN L'AIR

local handsup = false

function getSurrenderStatus()
	return handsup
end

RegisterNetEvent('KZ:getSurrenderStatusPlayer')
AddEventHandler('KZ:getSurrenderStatusPlayer', function(event, source)
	if handsup then
		TriggerServerEvent("KZ:reSendSurrenderStatus", event, source, true)
	else
		TriggerServerEvent("KZ:reSendSurrenderStatus", event, source, false)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local plyPed = PlayerPedId()

		if (IsControlJustPressed(1, 243) or IsDisabledControlJustPressed(1, 243)) then
			if DoesEntityExist(plyPed) and not IsEntityDead(plyPed) then
				if not IsPedInAnyVehicle(plyPed, false) and not IsPedSwimming(plyPed) and not IsPedShooting(plyPed) and not IsPedClimbing(plyPed) and not IsPedCuffed(plyPed) and not IsPedDiving(plyPed) and not IsPedFalling(plyPed) and not IsPedJumpingOutOfVehicle(plyPed) and not IsPedUsingAnyScenario(plyPed) and not IsPedInParachuteFreeFall(plyPed) then
					RequestAnimDict("random@mugging3")

					while not HasAnimDictLoaded("random@mugging3") do
						Citizen.Wait(100)
					end

					if not handsup then
						handsup = true
						TaskPlayAnim(plyPed, "random@mugging3", "handsup_standing_base", 8.0, -8, -1, 49, 0, 0, 0, 0)
					elseif handsup then
						handsup = false
						ClearPedSecondaryTask(plyPed)
					end
				end
			end
		end
	end
end)



----- POINTING
local mp_pointing = false
local keyPressed = false

local function startPointing()
    local ped = GetPlayerPed(-1)
    RequestAnimDict("anim@mp_point")
    while not HasAnimDictLoaded("anim@mp_point") do
        Citizen.Wait(0)
    end
    SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)
    SetPedConfigFlag(ped, 36, 1)
    Citizen.InvokeNative(0x2D537BA194896636, ped, "task_mp_pointing", 0.5, 0, "anim@mp_point", 24)
    RemoveAnimDict("anim@mp_point")
end

local function stopPointing()
    local ped = GetPlayerPed(-1)
    Citizen.InvokeNative(0xD01015C7316AE176, ped, "Stop")
    if not IsPedInjured(ped) then
        ClearPedSecondaryTask(ped)
    end
    if not IsPedInAnyVehicle(ped, 1) then
        SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
    end
    SetPedConfigFlag(ped, 36, 0)
    ClearPedSecondaryTask(PlayerPedId())
end

local once = true
local oldval = false
local oldvalped = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if once then
            once = false
        end

        if not keyPressed then
            if IsControlPressed(1, 29) and not mp_pointing and IsPedOnFoot(PlayerPedId()) then
                Citizen.Wait(200)
                if not IsControlPressed(1, 29) then
                    keyPressed = true
                    startPointing()
                    mp_pointing = true
                else
                    keyPressed = true
                    while IsControlPressed(1, 29) do
                        Citizen.Wait(50)
                    end
                end
            elseif (IsControlPressed(1, 29) and mp_pointing) or (not IsPedOnFoot(PlayerPedId()) and mp_pointing) then
                keyPressed = true
                mp_pointing = false
                stopPointing()
            end
        end

        if keyPressed then
            if not IsControlPressed(1, 29) then
                keyPressed = false
            end
        end
        if Citizen.InvokeNative(0x921CE12C489C4C41, PlayerPedId()) and not mp_pointing then
            stopPointing()
        end
        if Citizen.InvokeNative(0x921CE12C489C4C41, PlayerPedId()) then
            if not IsPedOnFoot(PlayerPedId()) then
                stopPointing()
            else
                local ped = GetPlayerPed(-1)
                local camPitch = GetGameplayCamRelativePitch()
                if camPitch < -70.0 then
                    camPitch = -70.0
                elseif camPitch > 42.0 then
                    camPitch = 42.0
                end
                camPitch = (camPitch + 70.0) / 112.0

                local camHeading = GetGameplayCamRelativeHeading()
                local cosCamHeading = Cos(camHeading)
                local sinCamHeading = Sin(camHeading)
                if camHeading < -180.0 then
                    camHeading = -180.0
                elseif camHeading > 180.0 then
                    camHeading = 180.0
                end
                camHeading = (camHeading + 180.0) / 360.0

                local blocked = 0
                local nn = 0

                local coords = GetOffsetFromEntityInWorldCoords(ped, (cosCamHeading * -0.2) - (sinCamHeading * (0.4 * camHeading + 0.3)), (sinCamHeading * -0.2) + (cosCamHeading * (0.4 * camHeading + 0.3)), 0.6)
                local ray = Cast_3dRayPointToPoint(coords.x, coords.y, coords.z - 0.2, coords.x, coords.y, coords.z + 0.2, 0.4, 95, ped, 7);
                nn,blocked,coords,coords = GetRaycastResult(ray)

                Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Pitch", camPitch)
                Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Heading", camHeading * -1.0 + 1.0)
                Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isBlocked", blocked)
                Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isFirstPerson", Citizen.InvokeNative(0xEE778F8C7E1142E2, Citizen.InvokeNative(0x19CAFA3C87F7C2FF)) == 4)

            end
        end
    end
end)






