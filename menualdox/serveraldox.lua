ESX = nil

TriggerEvent('esx:getShaldoxaredObjaldoxect', function(obj) ESX = obj end)



ESX.RegisterServerCallback('AldoxObjet:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb({items = items})
end)


ESX.RegisterServerCallback('aldoxmenu:billing', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local bills = {}

	MySQL.Async.fetchAll('SELECT * FROM billing WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		for i = 1, #result, 1 do
			table.insert(bills, {
				id = result[i].id,
				label = result[i].label,
				amount = result[i].amount
			})
		end

		cb({bills = bills})
	end)
end)


ESX.RegisterServerCallback('VInventory:billing', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local bills = {}

	MySQL.Async.fetchAll('SELECT * FROM billing WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		for i = 1, #result, 1 do
			table.insert(bills, {
				id = result[i].id,
				label = result[i].label,
				amount = result[i].amount
			})
		end

		cb(bills)
	end)
end)


ESX.RegisterUsableItem('boxsecrete', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('boxsecrete', 1)
	local randomwin = math.random(1,100)
	if randomwin == 1 then
		xPlayer.addInventoryItem("boxsecrete", 3)
		TriggerClientEvent('esx:showAdvancedNotification', xPlayer, "Information", "Street Kings", "~b~Vous gagnez~w~ 3 Box ~b~dans la Box", 8)
	elseif randomwin > 1 and randomwin < 21 then
		xPlayer.addInventoryItem("jeton", 350)
		TriggerClientEvent('esx:showAdvancedNotification', xPlayer, "Information", "Street Kings", "~b~Vous gagnez~w~ 350 Jetons ~b~dans la Box", 8)
	elseif randomwin > 20 and randomwin < 101 then
		xPlayer.addInventoryItem("jeton", 150)
		TriggerClientEvent('esx:showAdvancedNotification', xPlayer, "Information", "Street Kings", "~b~Vous gagnez~w~ 150 Jetons ~b~dans la Box", 8)
	end
end)


------ NOEL
ESX.RegisterServerCallback('aldox:statuscadeau', function(source, cb)
	local identifier = GetPlayerIdentifiers(source)[1]

	MySQL.Async.fetchScalar('SELECT cadeau FROM users WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(cadwonoel)
		

		cb(cadwonoel)
		print("Le status du Cadeau pour le joueur " .. identifier .. " est à " .. cadwonoel)
		
	end)
end)

RegisterServerEvent('aldox:clearcadeau')
AddEventHandler('aldox:clearcadeau', function()
	local identifier = GetPlayerIdentifiers(source)[1]
	local xPlayer = ESX.GetPlayerFromId(source)
	local quantity = math.random(1,2)

	xPlayer.addInventoryItem("boxsecrete", quantity)

	MySQL.Sync.execute('UPDATE users SET cadeau = @cadeau WHERE identifier = @identifier', {
		['@identifier'] = identifier,
		['@cadeau'] = "1",
	})
end)

RegisterServerEvent('aldox:primeetat')
AddEventHandler('aldox:primeetat', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local money = 1000
	xPlayer.addAccountMoney("bank", money)
end)


RegisterServerEvent('aldox:Retiregilet')
AddEventHandler('aldox:Retiregilet', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addInventoryItem("bulletproof", 1)
end)