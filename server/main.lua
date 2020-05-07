ESX = nil

TriggerEvent('pz:getSharedObject', function(obj) ESX = obj end)

local PlayersProducing	= {}
ESX.RegisterServerCallback("pz_loyalesbunker:retrieveVehicles", function(source, cb)
    MySQL.Async.fetchAll("SELECT car FROM loyales_bunker", {}, function(result)
        if result[1] ~= nil then
            for i = 1, #result, 1 do
				cb(json.decode(result[i]["car"]))
				break
            end
        end
    end)	
end)

local function StartProduction(source, machineType, itemID)
	local _source = source
	SetTimeout(Config.TimeToProcess[itemID]*1000, function()
		if PlayersProducing[_source] then	
			local xPlayer = ESX.GetPlayerFromId(_source)
			local item = xPlayer.getInventoryItem(itemID)

			if item.limit ~= -1 and item.count >= item.limit then
				TriggerClientEvent('pz:showNotification', source, "~r~Brak miejsca na ten przedmiot!")
				FreezeEntityPosition(_source, false)
			else
				xPlayer.addInventoryItem(itemID, 1)
				PlayersProducing[_source] = false
				FreezeEntityPosition(_source, false)
			end
		end
	end)
end

local function StartMakingAWeapon(source, itemID)
	local _source = source
	if PlayersProducing[_source] then	
		local xPlayer = ESX.GetPlayerFromId(_source)
		local action = string.gsub(itemID, "do", "")
		local item = xPlayer.getInventoryItem(action)	
		for k,v in pairs(Config.GunsProperties) do
			if v.Type ~= nil and v.Type == itemID then
					for l,s in pairs(v.need) do
						if xPlayer.getInventoryItem(s).count < 1 then
							TriggerClientEvent('pz:showNotification', _source, 'Nie posiadasz wszystkich części!')
							FreezeEntityPosition(_source, false)
							return
						end
					end
			break
			end
		end					
		if item.limit ~= -1 and item.count >= item.limit then
			TriggerClientEvent('pz:showNotification', source, "~r~Brak miejsca na ten przedmiot!")
			FreezeEntityPosition(_source, false)
			return
		else
			TriggerClientEvent('pz:showNotification', _source, 'Rozpoczęto składanie broni.')
			TriggerClientEvent('pz-loyalesbunker:startProcents', source, (Config.TimeToProcess[itemID]*1000)/100)				
		end
			
		SetTimeout(Config.TimeToProcess[itemID]*1000, function()
			if item.limit ~= -1 and item.count < item.limit then	
				xPlayer.addInventoryItem(action, 1)
				for k,v in pairs(Config.GunsProperties) do
					if v.Type ~= nil and v.Type == itemID then
							for l,s in pairs(v.need) do
								if xPlayer.getInventoryItem(s).count >= 1 then
									xPlayer.removeInventoryItem(s, 1)
								end
							end
					break
					end
				end	
				PlayersProducing[_source] = false
				FreezeEntityPosition(_source, false)
			end
		end) 
	end
end

RegisterServerEvent('pz-loyalesbunker:startProduction')
AddEventHandler('pz-loyalesbunker:startProduction', function(machineType, itemID)
	local _source = source
	if not PlayersProducing[_source] then
		PlayersProducing[_source] = true
		TriggerClientEvent('pz:showNotification', _source, 'Rozpoczęto produkcję!')
		StartProduction(_source, machineType, itemID)
		TriggerClientEvent('pz-loyalesbunker:startProcents', source, (Config.TimeToProcess[itemID]*1000)/100)		
	else
		print(('pz-loyalesbunker: %s attempted to exploit the marker!'):format(GetPlayerIdentifiers(_source)[1]))
	end		
end)

RegisterServerEvent('pz-loyalesbunker:stopProduction')
AddEventHandler('pz-loyalesbunker:stopProduction', function()
	local _source = source
	PlayersProducing[_source] = false
end)

RegisterServerEvent('pz-loyalesbunker:giveToMagazine')
AddEventHandler('pz-loyalesbunker:giveToMagazine', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local i = 0
	for k,v in pairs(Config.GunsProperties) do
		if v.name ~= nil and xPlayer.getInventoryItem(v.name).count > 0 then
			local gunCount = xPlayer.getInventoryItem(v.name).count
			MySQL.Async.execute("INSERT INTO loyales_bunker_depot (userID, amount, gunName) VALUES (@identifier, @cash, @gunName)",
				{
					["@identifier"] = xPlayer["identifier"],
					["@cash"] = v.price*gunCount,
					["@gunName"] = v.name,	
				}
			)
			xPlayer.removeInventoryItem(v.name, gunCount)
			i = i + gunCount
		end
	end
	TriggerClientEvent('pz:showNotification', _source, '~s~Oddano ~g~' .. i .. " ~s~sztuk broni do magazynu.")	
	TriggerClientEvent('pz:showNotification', _source, '~g~Pieniądze przyjdą na konto bankowe, gdy broń opuści magazyn!')

	CheckMoney()
end)

function CheckMoney()
	MySQL.Async.fetchAll('SELECT SUM(amount) FROM loyales_bunker_depot', {}, function(result)
		local cashBack = result[1]["SUM(amount)"]
		if cashBack ~= nil and cashBack > 500000 then
			GiveCashToPlayers()
			GiveCashToLoyales(cashBack)
		else
			print("Something went wrong, there was no cash!.")
		end
	end)	
end

function GiveCashToPlayers()
	MySQL.Async.fetchAll('SELECT DISTINCT userID FROM loyales_bunker_depot', {}, function(result)
		for k,v in pairs(result) do
			GivePlayerHisMoney(v["userID"])
		end
	end)	
end

function GivePlayerHisMoney(identifier)

local xPlayer = ESX.GetPlayerFromIdentifier(identifier)

	MySQL.Async.fetchAll('SELECT bank FROM users WHERE identifier = @identifier', { ["@identifier"] = identifier }, function(result)
		if result[1]["bank"] ~= nil then
			MySQL.Async.fetchAll('SELECT SUM(amount) FROM loyales_bunker_depot WHERE userID = @identifier', { ["@identifier"] = identifier }, function(result2)
				if result2[1]["SUM(amount)"] ~= nil then
					if xPlayer ~= nil then
						xPlayer.addMoney(result2[1]["SUM(amount)"]*0.4)
						TriggerClientEvent("pz:showNotification", xPlayer.source, "~r~ Otrzymałeś " .. result2[1]["SUM(amount)"]*0.4 .. "$ za pracę u ~y~Loyales'ów!")	
					else
						MySQL.Async.execute("UPDATE users SET bank = @newBank WHERE identifier = @identifier",
							{
								["@identifier"] = identifier,
								["@newBank"] = result[1]["bank"] + (result2[1]["SUM(amount)"]*0.4)
							}
						)
					end
					MySQL.Async.execute("DELETE FROM loyales_bunker_depot WHERE userID = @identifier",
						{
							["@identifier"] = identifier,
						}
					)					
				end
			end)
		end
	end)
end

function GiveCashToLoyales(amount)
  TriggerEvent('pz_addonaccount:getSharedAccount', 'society_loyales', function(account)
      account.addMoney(amount)
  end)	
end

RegisterServerEvent('pz-loyalesbunker:startMakingAWeapon')
AddEventHandler('pz-loyalesbunker:startMakingAWeapon', function(itemID)
	local _source = source
	if not PlayersProducing[_source] then
		PlayersProducing[_source] = true
		StartMakingAWeapon(_source, itemID)
	else
		print(('pz-loyalesbunker: %s attempted to exploit the marker!'):format(GetPlayerIdentifiers(_source)[1]))
	end		
end)

RegisterServerEvent('pz-loyalesbunker:putWeaponInMagazine')
AddEventHandler('pz-loyalesbunker:putWeaponInMagazine', function(itemID)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeInventoryItem(itemID, 1)
	local gunLabel
	for k, id in ipairs(Config.WeaponNames) do
		if id.itemName == itemID then
			gunLabel = id.label
			break
		end
	end	
    MySQL.Async.fetchAll("SELECT amount	FROM loyales_bunker_magazine WHERE gunName = @itemID AND userID = @identifier", {
		["@itemID"] = itemID,
		["@identifier"] = xPlayer["identifier"]		
	}, function(result)
        if result[1] ~= nil then
			MySQL.Async.execute("UPDATE loyales_bunker_magazine SET amount = @newAmount WHERE userID = @identifier AND gunName = @itemID",
			{
				["@identifier"] = xPlayer["identifier"],
				["@newAmount"] = result[1]["amount"] + 1,
				["@itemID"] = itemID,				
			})		
		else
			MySQL.Async.execute("INSERT INTO loyales_bunker_magazine (userID, amount, gunName, gunLabel) VALUES (@identifier, @amount, @gunName, @gunLabel)",
			{
				["@identifier"] = xPlayer["identifier"],
				["@amount"] = 1,
				["@gunName"] = itemID,	
				["@gunLabel"] = gunLabel,					
			})
        end
    end)	
end)

ESX.RegisterServerCallback('pz-loyalesbunker:getMagazineWeapons', function(source, cb, itemID)
	local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll("SELECT * FROM loyales_bunker_magazine WHERE userID = @identifier", {
		["@identifier"] = xPlayer["identifier"]		
	}, function(result)
		local weaponsTable = {}
        if result[1] ~= nil then
			for k,v in pairs(result) do
				table.insert(weaponsTable, 
				{
					["label"] = result[k]["gunLabel"],
					["id"] = result[k]["gunName"],
					["count"] = result[k]["amount"]
				})
			end		

        end
		cb(weaponsTable)
    end)
end)
ESX.RegisterServerCallback('pz-loyalesbunker:canProduce', function(source, cb, itemID)
	local xPlayer = ESX.GetPlayerFromId(source)
	local canProduce = false
	local item = xPlayer.getInventoryItem(itemID)
	if item.limit ~= -1 and item.count < item.limit then	
		canProduce = true
	end
	cb(canProduce)
end)

RegisterServerEvent('pz-loyalesbunker:getWeaponFromMagazine')
AddEventHandler('pz-loyalesbunker:getWeaponFromMagazine', function(itemLabel)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local itemID
	for k, id in ipairs(Config.WeaponNames) do
		if id.label == itemLabel then
			itemID = id.itemName
			break
		end
	end	
	
	local item = xPlayer.getInventoryItem(itemID)
	if item.limit ~= -1 and item.count < item.limit then
		MySQL.Async.fetchAll("SELECT amount	FROM loyales_bunker_magazine WHERE gunName = @itemID AND userID = @identifier", {
			["@itemID"] = itemID,
			["@identifier"] = xPlayer["identifier"]		
		}, function(result)
			if result[1] ~= nil then
				MySQL.Async.execute("UPDATE loyales_bunker_magazine SET amount = @newAmount WHERE userID = @identifier AND gunName = @itemID",
				{
					["@identifier"] = xPlayer["identifier"],
					["@newAmount"] = result[1]["amount"] - 1,
					["@itemID"] = itemID,				
				})

				xPlayer.addInventoryItem(itemID, 1)			
			end
		end)	
	else
		TriggerClientEvent('pz:showNotification', source, "~r~Brak miejsca na ten przedmiot!")	
	end
end)


RegisterServerEvent('pz-loyalesbunker:sellWeaponInShop')
AddEventHandler('pz-loyalesbunker:sellWeaponInShop', function(itemLabel)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	for k,v in pairs(Config.GunsProperties) do
		if v.name == itemLabel and xPlayer.getInventoryItem(v.name).count > 0 then
			xPlayer.removeInventoryItem(v.name, 1)
			xPlayer.addMoney(v.price*0.4)
			TriggerClientEvent('pz:showNotification', source, "~r~Sprzedałeś broń za ~b~" .. v.price*0.4 .. "~g~$")
			GiveCashToLoyales(v.price)		
		end
	end
end)

RegisterServerEvent('pz-loyalesbunker:sellWeaponInIllegalShop')
AddEventHandler('pz-loyalesbunker:sellWeaponInIllegalShop', function(itemLabel)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	for k,v in pairs(Config.GunsProperties) do
		if v.name == itemLabel and xPlayer.getInventoryItem(v.name).count > 0 then
			xPlayer.removeInventoryItem(v.name, 1)
			xPlayer.addMoney(v.price*0.2)
			TriggerClientEvent('pz:showNotification', source, "~r~Sprzedałeś broń za ~b~" .. v.price*0.25 .. "~g~$")		
		end
	end
end)

ESX.RegisterServerCallback('pz-loyalesbunker:DoesPedHaveMagneticCard', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local item = xPlayer.getInventoryItem('loyalescard')
	if item.count > 0 then
		cb(true)
	else
		cb(false)
	end
end)

RegisterServerEvent('pz-loyalesbunker:createCard')
AddEventHandler('pz-loyalesbunker:createCard', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local item = xPlayer.getInventoryItem('loyalescard')
	if item.limit ~= -1 and item.count < item.limit then
		xPlayer.addInventoryItem('loyalescard', 1)
	else
		TriggerClientEvent('pz:showNotification', source, "~r~Brak miejsca na ten przedmiot!")		
	end
end)

RegisterServerEvent('pz-loyalesbunker:createGPSRouteAndMarkersForSell')
AddEventHandler('pz-loyalesbunker:createGPSRouteAndMarkersForSell', function(playerID, randomValue)
	TriggerClientEvent('pz-loyalesbunker:throwGPSAndOtherDirectlyToPlayer', playerID, randomValue)			
end)