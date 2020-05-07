ESX = nil
local showProcentsAmount = false
PlayerData = {}
BlipCoords = {}
VehicleIsSpawning = false
Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(10)

        TriggerEvent("pz:getSharedObject", function(response)
            ESX = response
        end)
    end

    if ESX.IsPlayerLoaded() then
		PlayerData = ESX.GetPlayerData()
		RemoveVehicles()

		Citizen.Wait(500)

		LoadBlipsAndMarkers()

		SpawnVehicles()
    end
end)

RegisterNetEvent("pz:playerLoaded")
AddEventHandler("pz:playerLoaded", function(response)
	PlayerData = response
	PlayerData.ringed = false
	LoadBlipsAndMarkers()

	SpawnVehicles()
end)

RegisterNetEvent('pz:setJob')
AddEventHandler('pz:setJob', function(job)
	PlayerData.job = job
end)

function LoadBlipsAndMarkers()
	Citizen.CreateThread(function()

		local VehPos = Config.VehPosition
		local TextPos = Config.TextPosition
		local Blip = AddBlipForCoord(VehPos["x"], VehPos["y"], VehPos["z"])
		local TeleportCoords = Config.TeleportPosition
		local exitTextPos = Config.exitTextPosition	
		local exitCoords = Config.ExitTeleport
		local magazineTextPosition = Config.MagazineTextPosition	
		local clothMenuLocation = Config.clothMenuLocation
		local CarSpawnTextPosition = Config.CarSpawnTextPosition
		local AutoExitTextPosition = Config.AutoExitTextPosition		
		local IllegalSellTextPosition = Config.IllegalSellTextPosition	
		
		SetBlipSprite (Blip, 160)
		SetBlipDisplay(Blip, 4)
		SetBlipScale  (Blip, 1.5)
		SetBlipColour (Blip, 47)
		SetBlipCategory(Blip, 3)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Loyales - produkcja broni")
		EndTextCommandSetBlipName(Blip)
		SetBlipAsShortRange(Blip, true)	
		
		while true do
			local sleepThread = 500

			local ped = PlayerPedId()
			local pedCoords = GetEntityCoords(ped)

			local dstCheck = GetDistanceBetweenCoords(pedCoords, VehPos["x"], VehPos["y"], VehPos["z"], true)
			
			if dstCheck <= 20.0 then
				sleepThread = 5
				
				if dstCheck <= 1.0 then
					if IsPedInAnyVehicle(ped, false) then
						if not PlayerData.messageReceived then
							PlayerData.messageReceived = true
							ESX.ShowNotification('~g~Przeciągnij ~b~kartę magnetyczną ~g~przez terminal. ~r~[E]')	
						else
							if IsControlJustPressed(0, 38) then
								TeleportPlayerToFactory()
							end
						end
					elseif PlayerData.messageReceived then		
						PlayerData.messageReceived = false
					end
				elseif PlayerData.messageReceived then
					PlayerData.messageReceived = false
				end
			end

			if GetDistanceBetweenCoords(pedCoords, Config.ExitPosition["x"], Config.ExitPosition["y"], Config.ExitPosition["z"],  true) < 100.0 then
				sleepThread = 5
				DrawMarker(1, Config.ExitPosition["x"], Config.ExitPosition["y"], Config.ExitPosition["z"], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 255, 50, 0, 100, false, true, 2, false, false, false, false)
				if GetDistanceBetweenCoords(pedCoords, Config.ExitPosition["x"], Config.ExitPosition["y"], Config.ExitPosition["z"],  true) < 15.0 then				
					ESX.Game.Utils.DrawText3D(exitTextPos, "~g~[E] ~r~WYJŚCIE", 1.5)
					if GetDistanceBetweenCoords(pedCoords, Config.ExitPosition["x"], Config.ExitPosition["y"], Config.ExitPosition["z"], true) < 2.0 then
						if IsControlJustPressed(0, 38) then
							Teleport(exitCoords)
						end
					end
				end
			end
			
			if GetDistanceBetweenCoords(pedCoords, Config.IllegalSellPosition["x"], Config.IllegalSellPosition["y"], Config.IllegalSellPosition["z"],  true) < 100.0 then
				sleepThread = 5
				DrawMarker(1, Config.IllegalSellPosition["x"], Config.IllegalSellPosition["y"], Config.IllegalSellPosition["z"], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 255, 50, 0, 100, false, true, 2, false, false, false, false)
				if GetDistanceBetweenCoords(pedCoords, Config.IllegalSellPosition["x"], Config.IllegalSellPosition["y"], Config.IllegalSellPosition["z"],  true) < 15.0 then				
					ESX.Game.Utils.DrawText3D(IllegalSellTextPosition, "~g~[E] ~r~Wyładuj broń", 1.0)
					if GetDistanceBetweenCoords(pedCoords, Config.IllegalSellPosition["x"], Config.IllegalSellPosition["y"], Config.IllegalSellPosition["z"], true) < 2.0 then
						if IsControlJustPressed(0, 38) then
							OpenIllegalSellMenu()
						end
					end
				end
			end	
			
			if PlayerData.job.name == 'loyales' or PlayerData.job.name == 'loyalesprod' then
				if GetDistanceBetweenCoords(pedCoords, Config.MagazinePosition["x"], Config.MagazinePosition["y"], Config.MagazinePosition["z"],  true) < 100.0 then
					sleepThread = 5
					DrawMarker(31, Config.MagazinePosition["x"], Config.MagazinePosition["y"], Config.MagazinePosition["z"], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 255, 189, 27, 100, false, true, 2, false, false, false, false)
					if GetDistanceBetweenCoords(pedCoords, Config.MagazinePosition["x"], Config.MagazinePosition["y"], Config.MagazinePosition["z"],  true) < 15.0 then				
						ESX.Game.Utils.DrawText3D(magazineTextPosition, "~g~[E] ~r~ MAGAZYN", 2.0)
						if GetDistanceBetweenCoords(pedCoords, Config.MagazinePosition["x"], Config.MagazinePosition["y"], Config.MagazinePosition["z"], true) < 3.0 then
							if IsControlJustPressed(0, 38) then
								OpenMagazine()
							end
						end
					end
				end	
			
				for i = 1, #Config.Markers, 1 do
					if Config.Markers[i]["x"] ~= nil then
						local markerPos = Config.Markers[i]				
						local dstCheckMarker = GetDistanceBetweenCoords(pedCoords, Config.Markers[i]["x"], Config.Markers[i]["y"], Config.Markers[i]["z"], true)
						if dstCheckMarker <= 40.0 then
							sleepThread = 5
							if Config.Markers[i]["type"] == "wiertarka" or Config.Markers[i]["type"] == "duzawiertarka" then
								DrawMarker(1, Config.Markers[i]["x"], Config.Markers[i]["y"], Config.Markers[i]["z"]-1.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 0, 0, 255, 100, false, true, 2, false, false, false, false)
							elseif Config.Markers[i]["type"] == "frezarka" then
								DrawMarker(1, Config.Markers[i]["x"], Config.Markers[i]["y"], Config.Markers[i]["z"]-1.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 255, 255, 0, 100, false, true, 2, false, false, false, false)
							elseif Config.Markers[i]["type"] == "tokarka" then
								DrawMarker(1, Config.Markers[i]["x"], Config.Markers[i]["y"], Config.Markers[i]["z"]-1.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 50, 255, 100, 100, false, true, 2, false, false, false, false)
							elseif Config.Markers[i]["type"] == "dokumenty" then
								DrawMarker(1, Config.Markers[i]["x"], Config.Markers[i]["y"], Config.Markers[i]["z"]-1.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 0, 255, 0, 100, false, true, 2, false, false, false, false)
							else
								DrawMarker(1, Config.Markers[i]["x"], Config.Markers[i]["y"], Config.Markers[i]["z"]-1.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 255, 0, 0, 100, false, true, 2, false, false, false, false)
							end
						end
						
						if dstCheckMarker <= 3.0 then
							local text = ""
							if Config.Markers[i]["type"] == "wiertarka" or Config.Markers[i]["type"] == "duzawiertarka" then
								text = "~g~[E] ~r~Użyj wiertarki"
							elseif Config.Markers[i]["type"] == "frezarka" then
								text = "~g~[E] ~r~Użyj frezarki"
							elseif Config.Markers[i]["type"] == "tokarka" then
								text = "~g~[E] ~r~Użyj tokarki"		
							elseif Config.Markers[i]["type"] == "dokumenty" then
								text = "~g~[E] ~r~Sprawdź plany"	
							else
								text = "~g~[E] ~r~Składaj broń"		
							end
							ESX.Game.Utils.DrawText3D(markerPos, text, 1.5)
						end
						if dstCheckMarker <= 0.6 then 
							if IsControlJustPressed(0, 38) and not PlayerData.producing then
								OpenWorkMenu(Config.Markers[i]["type"])	
								PlayerData.wasInMarker = true
								PlayerData.lastMarker = i
							end	
						end
						if dstCheckMarker > 0.6 and PlayerData.wasInMarker and i == PlayerData.lastMarker then
							PlayerData.wasInMarker = false
							TriggerServerEvent('pz-loyalesbunker:stopProduction')
							showProcentsAmount = false
							PlayerData.producing = false
							ESX.UI.Menu.CloseAll()
						end
					end					
				end	
			
				if GetDistanceBetweenCoords(pedCoords, Config.CarSpawnPosition["x"], Config.CarSpawnPosition["y"], Config.CarSpawnPosition["z"],  true) < 100.0 then
					sleepThread = 5
					DrawMarker(1, Config.CarSpawnPosition["x"], Config.CarSpawnPosition["y"], Config.CarSpawnPosition["z"], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 5.0, 5.0, 1.0, 255, 33, 27, 100, false, true, 2, false, false, false, false)
					if GetDistanceBetweenCoords(pedCoords, Config.CarSpawnPosition["x"], Config.CarSpawnPosition["y"], Config.CarSpawnPosition["z"],  true) < 15.0 then				
						ESX.Game.Utils.DrawText3D(CarSpawnTextPosition, "~g~[E] ~r~WEŹ AUTO DOSTAWCZE", 2.0)
						if GetDistanceBetweenCoords(pedCoords, Config.CarSpawnPosition["x"], Config.CarSpawnPosition["y"], Config.CarSpawnPosition["z"], true) < 3.0 then	
							if IsControlJustPressed(0, 38) and not IsPedInAnyVehicle(ped, false) and not VehicleIsSpawning then
								if GetClosestVehicle(pedCoords, 20.0,0, 70) == 0.0 then
									spawnLoyalesVehicle()		
								else
									ESX.ShowHelpNotification('~r~Aktualnie w pobliżu znajduje się już auto dostawcze!')
								end
							end
						end
					end
				end	
			
				if GetDistanceBetweenCoords(pedCoords, Config.AutoExitPosition["x"], Config.AutoExitPosition["y"], Config.AutoExitPosition["z"],  true) < 100.0 then
					sleepThread = 5
					DrawMarker(1, Config.AutoExitPosition["x"], Config.AutoExitPosition["y"], Config.AutoExitPosition["z"], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 5.0, 5.0, 1.0, 77, 33, 27, 100, false, true, 2, false, false, false, false)
					if GetDistanceBetweenCoords(pedCoords, Config.AutoExitPosition["x"], Config.AutoExitPosition["y"], Config.AutoExitPosition["z"],  true) < 15.0 then				
						ESX.Game.Utils.DrawText3D(AutoExitTextPosition, "~g~[E] ~r~WYJEDŹ", 2.0)
						if GetDistanceBetweenCoords(pedCoords, Config.AutoExitPosition["x"], Config.AutoExitPosition["y"], Config.AutoExitPosition["z"], true) < 3.0 then
							if IsControlJustPressed(0, 38) then
								if IsPedInAnyVehicle(ped, true) then
									teleportToRandomBunkerExit(ped)
								else
									ESX.ShowHelpNotification('Musisz być w aucie dostawczym!')							
								end
							end
						end
					end
				end				
			end
			
			if PlayerData.job.name == 'loyales' and GetDistanceBetweenCoords(pedCoords, Config.clothMenuLocation["x"], Config.clothMenuLocation["y"], Config.clothMenuLocation["z"],  true) < 100.0 then
				sleepThread = 5
				DrawMarker(1, Config.clothMenuLocation["x"], Config.clothMenuLocation["y"], Config.clothMenuLocation["z"], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 255, 50, 0, 100, false, true, 2, false, false, false, false)			
				if GetDistanceBetweenCoords(pedCoords, Config.clothMenuLocation["x"], Config.clothMenuLocation["y"], Config.clothMenuLocation["z"], true) < 1.2 then
					ESX.ShowHelpNotification('~g~[E] ~y~Garderoba')
					if IsControlJustPressed(0, 38) then
						OpenClothesMenu()
					end
				end
			end	
			
			if PlayerData.job.name == 'loyales' and GetDistanceBetweenCoords(pedCoords, Config.CardCreatingPosition["x"], Config.CardCreatingPosition["y"], Config.CardCreatingPosition["z"],  true) < 100.0 then
				sleepThread = 5
				DrawMarker(1, Config.CardCreatingPosition["x"], Config.CardCreatingPosition["y"], Config.CardCreatingPosition["z"], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 255, 50, 0, 100, false, true, 2, false, false, false, false)			
				if GetDistanceBetweenCoords(pedCoords, Config.CardCreatingPosition["x"], Config.CardCreatingPosition["y"], Config.CardCreatingPosition["z"], true) < 1.2 then
					ESX.ShowHelpNotification('~g~[E] ~y~Zaprogramuj kartę')
					if IsControlJustPressed(0, 38) then
						CreateCard()
					end
				end
			end	
			
			
			Citizen.Wait(sleepThread)
		end
	end)
end
function OpenMagazine()
	local elements = {}
	ESX.UI.Menu.CloseAll()	
	table.insert(elements, { ["label"] = "Odłóż do magazynu", ["value"] = "give"})			
	table.insert(elements, { ["label"] = "Wyciągnij z magazynu", ["value"] = "get"})	
	FreezeEntityPosition(GetPlayerPed(-1), true)	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'magazine_menu',
		{
			title    = 'Magazyn',
			align    = 'bottom-left',
			elements = elements
		},
		function(data, menu)
			local action = data.current.value
			if action == 'give' then
				ESX.TriggerServerCallback("pz_inventoryhud:getPlayerInventory", function(data)
						items = {}
						inventory = data.inventory
						
						if inventory ~= nil then
							for key, value in pairs(inventory) do
								if inventory[key].count <= 0 then
									inventory[key] = nil
								else
									inventory[key].type = "item_standard" 
									for k, id in ipairs(Config.WeaponNames) do
										if inventory[key].label == id.label then
											table.insert(items, { ["label"] = inventory[key].label .. " " .. inventory[key].count .. "x", ["value"] = id.itemName})	
											break
										end
									end	
								end
							end
							ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'magazine_menu_put', {
								title    = 'Magazyn',
								align    = 'bottom-left',
								elements = items
							}, 
								function(data2, menu2)
									TriggerServerEvent('pz-loyalesbunker:putWeaponInMagazine', data2.current.value)
									menu2.close()
								end, function(data2, menu2)
								menu2.close()
								menu.close()								
							end)	
						end
				end, GetPlayerServerId(PlayerId()))		
			elseif action == 'get' then
				ESX.TriggerServerCallback("pz-loyalesbunker:getMagazineWeapons", function(data)
						local weaponsInMagazine = {}
						inventory = data
						if inventory ~= nil then
							for k,v in pairs(inventory) do
								if inventory[k]["count"] > 0 then
									table.insert(weaponsInMagazine, { ["label"] = inventory[k]["label"] .. " " .. inventory[k]["count"] .. "x", ["value"] = inventory[k]["label"]})	
								end
							end
							ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'magazine_menu_get', {
								title    = 'Magazyn',
								align    = 'bottom-left',
								elements = weaponsInMagazine
							}, 
								function(data3, menu3)
									TriggerServerEvent('pz-loyalesbunker:getWeaponFromMagazine', data3.current.value)								
									menu3.close()
								end, function(data3, menu3)
								menu3.close()
								menu.close()								
							end)								
						end
				end)		
			end
		end, function(data, menu)
		menu.close()
		FreezeEntityPosition(GetPlayerPed(-1), false)		
	end)
end
function OpenWorkMenu(machineType)
	local elements = {}
	local menuTitle
	if machineType == "wiertarka" or machineType == "duzawiertarka" then
		menuTitle = "Loyales - produkcja broni : Wiertarka"
		table.insert(elements, { ["label"] = "Uchwyt karabinu szturmowego", ["value"] = "uchwytKSZ"})
		table.insert(elements, { ["label"] = "Uchwyt karabinu snajperskiego", ["value"] = "uchwytKS"})
		table.insert(elements, { ["label"] = "Uchwyt strzelby tłokowej", ["value"] = "uchwytST"})
		table.insert(elements, { ["label"] = "Uchwyt rewolweru", ["value"] = "uchwytRW"})
		table.insert(elements, { ["label"] = "Uchwyt SMG", ["value"] = "uchwytSMG"})
		table.insert(elements, { ["label"] = "Uchwyt BKM", ["value"] = "uchwytBKM"})
		table.insert(elements, { ["label"] = "Uchwyt paralizatora", ["value"] = "uchwytTASER"})
		table.insert(elements, { ["label"] = "Chwyt BKM", ["value"] = "chwytBKM"})		
		table.insert(elements, { ["label"] = "Kolba BKM", ["value"] = "kolbaBKM"})		
		table.insert(elements, { ["label"] = "Magazynek BKM", ["value"] = "magazynekBKM"})
		table.insert(elements, { ["label"] = "Magazynek karabinu szturmowego", ["value"] = "magazynekKSZ"})
		table.insert(elements, { ["label"] = "Magazynek pistoletu przeciwpancernego", ["value"] = "magazynekPPP"})		
		table.insert(elements, { ["label"] = "Magazynek SMG", ["value"] = "magazynekSMG"})		
	
	elseif machineType == "frezarka" then
		menuTitle = "Loyales - produkcja broni : Frezarka"
		table.insert(elements, { ["label"] = "Szkielet karabinu szturmowego", ["value"] = "szkieletKSZ"})		
		table.insert(elements, { ["label"] = "Szkielet pistoletu przeciwpancernego", ["value"] = "szkieletPPP"})		
		table.insert(elements, { ["label"] = "Szkielet karabinu snajperskiego", ["value"] = "szkieletKS"})	
		table.insert(elements, { ["label"] = "Szkielet strzelby tłokowej", ["value"] = "szkieletST"})	
		table.insert(elements, { ["label"] = "Szkielet rewolweru", ["value"] = "szkieletRW"})			
		table.insert(elements, { ["label"] = "Szkielet SMG", ["value"] = "szkieletSMG"})			
		table.insert(elements, { ["label"] = "Szkielet paralizatora", ["value"] = "szkieletTASER"})	
		table.insert(elements, { ["label"] = "Mechanizm paralizatora", ["value"] = "mechanizmTASER"})			
		table.insert(elements, { ["label"] = "Mechanizm ładujący", ["value"] = "mechanizmLADUJACY"})				
		table.insert(elements, { ["label"] = "Mechanizm tłokowy", ["value"] = "mechanizmTLOKOWY"})				
		table.insert(elements, { ["label"] = "Cylinder", ["value"] = "cylinder"})				
		table.insert(elements, { ["label"] = "Szpilka łącząca", ["value"] = "szpilkaLACZACA"})							
	elseif machineType == "tokarka" then
		menuTitle = "Loyales - produkcja broni : Tokarka"
		table.insert(elements, { ["label"] = "Lufa karabinu szturmowego", ["value"] = "lufaKSZ"})		
		table.insert(elements, { ["label"] = "Lufa pistoletu przeciwpancernego", ["value"] = "lufaPPP"})		
		table.insert(elements, { ["label"] = "Lufa karabinu snajperskiego", ["value"] = "lufaKS"})	
		table.insert(elements, { ["label"] = "Lufa BKM", ["value"] = "lufaBKM"})	
		table.insert(elements, { ["label"] = "Lufa rewolweru", ["value"] = "lufaRW"})			
		table.insert(elements, { ["label"] = "Luneta karabinu snajperskiego", ["value"] = "lunetaKS"})		
	
	elseif machineType == "dokumenty" then
		menuTitle = "Loyales - produkcja broni : Plany broni"
		table.insert(elements, { ["label"] = "Karabin szturmowy", ["value"] = "KSZ"})			
		table.insert(elements, { ["label"] = "Pistolet przeciwpancerny", ["value"] = "PPP"})			
		table.insert(elements, { ["label"] = "Karabin snajperski", ["value"] = "KS"})			
		table.insert(elements, { ["label"] = "Strzelba tłokowa", ["value"] = "ST"})			
		table.insert(elements, { ["label"] = "Rewolwer", ["value"] = "RW"})			
		table.insert(elements, { ["label"] = "SMG", ["value"] = "SMG"})			
		table.insert(elements, { ["label"] = "Bojowy karabin maszynowy (BKM)", ["value"] = "BKM"})			
		table.insert(elements, { ["label"] = "Paralizator", ["value"] = "TASER"})			
	else
		menuTitle = "Loyales - produkcja broni : Stół monterski"		
		table.insert(elements, { ["label"] = "Złóż karabin szturmowy", ["value"] = "doKSZ"})			
		table.insert(elements, { ["label"] = "Złóż pistolet przeciwpancerny", ["value"] = "doPPP"})			
		table.insert(elements, { ["label"] = "Złóż karabin snajperski", ["value"] = "doKS"})			
		table.insert(elements, { ["label"] = "Złóż strzelbę tłokową", ["value"] = "doST"})			
		table.insert(elements, { ["label"] = "Złóż rewolwer", ["value"] = "doRW"})			
		table.insert(elements, { ["label"] = "Złóż SMG", ["value"] = "doSMG"})			
		table.insert(elements, { ["label"] = "Złóż bojowy karabin maszynowy (BKM)", ["value"] = "doBKM"})			
		table.insert(elements, { ["label"] = "Złóż paralizator", ["value"] = "doTASER"})					
	end
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'work_menu',
		{
			title    = menuTitle,
			align    = 'bottom-right',
			elements = elements
		},
	function(data, menu)
		local action = data.current.value
		TriggerServerEvent('pz-loyalesbunker:stopProduction')		
		showProcentsAmount = false	
		if action ~= "KSZ" and action ~= "PPP" and action ~= "KS" and action ~= "ST" and action ~= "RW" and action ~= "SMG" and action ~= "BKM" and action ~= "TASER" then
			if action ~= "doKSZ" and action ~= "doPPP" and action ~= "doKS" and action ~= "doST" and action ~= "doRW" and action ~= "doSMG" and action ~= "doBKM" and action ~= "doTASER" then
				if not PlayerData.producing then
					ESX.TriggerServerCallback("pz-loyalesbunker:canProduce", function(can)
						if can then
							TriggerServerEvent('pz-loyalesbunker:startProduction', machineType, action)
							FreezeEntityPosition(GetPlayerPed(-1), true)
							PlayerData.producing = true
							ESX.UI.Menu.CloseAll()
						else
							ESX.ShowNotification('Nie zmieścisz tego więcej!')
						end
					end, action)
				end
			else
				if not PlayerData.producing then
					TriggerServerEvent('pz-loyalesbunker:startMakingAWeapon', action)
					FreezeEntityPosition(GetPlayerPed(-1), true)
					PlayerData.producing = true
					ESX.UI.Menu.CloseAll()
				end
			end
		else
			TriggerEvent('chatMessage', "^2[^3Loyales - produkcja broni^2]", { 147, 196, 109 }, PrintWeaponPlanes(action))		
		end
	end, function(data, menu)
		menu.close()
		TriggerServerEvent('pz-loyalesbunker:stopProduction')
		PlayerData.producing = false
		showProcentsAmount = false		
	end)
end

function PrintWeaponPlanes(weapon)
	local txt
	if weapon == "KSZ" then 
		txt = "\n^1Karabin szturmowy:^2\n* Uchwyt karabinu szturmowego\n* Szkielet karabinu szturmowego\n* Lufa karabinu szturmowego\n* Magazynek karabinu szturmowego"
	elseif weapon == "PPP" then
		txt = "\n^1Pistolet przeciwpancerny:^2\n* Szkielet pistoletu przeciwpancernego\n* Lufa pistoletu przeciwpancernego\n* Magazynek pistoletu przeciwpancernego"	
	elseif weapon == "KS" then
		txt = "\n^1Karabin snajperski:^2\n* Uchwyt karabinu snajperskiego\n* Szkielet karabinu snajperskiego\n* Lufa karabinu snajperskiego\n* Luneta karabinu snajperskiego\n* Mechanizm ładujący"	
	elseif weapon == "ST" then
		txt = "\n^1Strzelba tłokowa:^2\n* Uchwyt strzelby tłokowej\n* Szkielet strzelby tłokowej\n* Mechanizm tłokowy\n* Mechanizm ładujący"	
	elseif weapon == "RW" then
		txt = "\n^1Rewolwer:^2\n* Uchwyt rewolweru\n* Cylinder\n* Szkielet rewolweru\n* Lufa rewolweru"	
	elseif weapon == "SMG" then
		txt = "\n^1SMG:^2\n* Uchwyt SMG\n* Szkielet SMG\n* Szpilka łącząca\n* Magazynek SMG"	
	elseif weapon == "BKM" then
		txt = "\n^1Bojowy karabin maszynowy (BKM):^2\n* Uchwyt bojowego karabinu maszynowego\n* Kolba BKM\n* Lufa bojowego karabinu maszynowego\n* Chwyt bojowego karabinu maszynowego\n* Magazynek bojowego karabinu maszynowego"	
	elseif weapon == "TASER" then
		txt = "\n^1Paralizator:^2\n* Uchwyt paralizatora\n* Szkielet paralizatora\n* Mechanizm paralizatora"	
	end
	return txt
end
function RemoveVehicles()
	local VehPos = Config.VehPosition

	for i = 1, #VehPos, 1 do
		local veh, distance = ESX.Game.GetClosestVehicle(VehPos[i]) 

		if DoesEntityExist(veh) and distance <= 1.0 then
			DeleteEntity(veh)
		end
	end
end

function SpawnVehicles()
	local VehPos = Config.VehPosition
	local vehicle
	ESX.TriggerServerCallback("pz_loyalesbunker:retrieveVehicles", function(vehicles)
			local vehicleProps = vehicles
			LoadModel(vehicleProps["model"])

			vehicle = CreateVehicle(vehicleProps["model"], VehPos["x"], VehPos["y"], VehPos["z"], VehPos["h"], false)

			ESX.Game.SetVehicleProperties(vehicle, vehicleProps)

			FreezeEntityPosition(vehicle, true)

			SetEntityAsMissionEntity(vehicle, true, true)
			SetModelAsNoLongerNeeded(vehicleProps["model"])
	end)
end

LoadModel = function(model)
	while not HasModelLoaded(model) do
		RequestModel(model)

		Citizen.Wait(1)
	end
end

RegisterNetEvent('gcPhone:numberCheck')
AddEventHandler("gcPhone:numberCheck", function(initiator, phone_number)
	phone_number = phone_number:gsub('%-', '')
	if phone_number=='2510#2210' then
		PlayerData.ringed = true
	end
end)

function Teleport(table)
	DoScreenFadeOut(100)
	Citizen.Wait(750)
	ESX.Game.Teleport(PlayerPedId(), table)
	DoScreenFadeIn(100)
end


function procent(time)
	TriggerEvent('pz-loyalesbunker:showProcents')
	TimeLeft = 0
	repeat
	TimeLeft = TimeLeft + 1
	Citizen.Wait(time)
	until(TimeLeft == 100)
	showProcentsAmount = false
	cooldownclick = false
  end


RegisterNetEvent('pz-loyalesbunker:showProcents')
AddEventHandler('pz-loyalesbunker:showProcents', function()
  showProcentsAmount = true
    while (showProcentsAmount) do
      Citizen.Wait(8)
      local playerPed = PlayerPedId()
      local coords = GetEntityCoords(playerPed)
      DrawText3D(coords.x, coords.y, coords.z+0.1,'Praca...' , 0.4)
      DrawText3D(coords.x, coords.y, coords.z, TimeLeft .. '~g~%', 0.4)
    end
end)

function DrawText3D(x, y, z, text, scale)
  local onScreen, _x, _y = World3dToScreen2d(x, y, z)
  local pX, pY, pZ = table.unpack(GetGameplayCamCoords())

  SetTextScale(scale, scale)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextEntry("STRING")
  SetTextCentre(1)
  SetTextColour(255, 255, 255, 255)
  SetTextOutline()

  AddTextComponentString(text)
  DrawText(_x, _y)

  local factor = (string.len(text)) / 270
  DrawRect(_x, _y + 0.015, 0.005 + factor, 0.03, 31, 31, 31, 155)
end

RegisterNetEvent('pz-loyalesbunker:startProcents')
AddEventHandler('pz-loyalesbunker:startProcents', function(productionTime)
	procent(productionTime)
end)

function OpenClothesMenu()
	local elements = {}
	
	table.insert(elements, {label = 'Ubrania', value = 'player_dressing'})
	table.insert(elements, {label = 'Usuń ubrania', value = 'remove_cloth'})

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'room', {
		title    = 'Garderoba',
		align    = 'left',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'player_dressing' then
			ESX.TriggerServerCallback('pz_property:getPlayerDressing', function(dressing)
				local elements = {}

				for i=1, #dressing, 1 do
					table.insert(elements, {
						label = dressing[i],
						value = i
					})
				end

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_dressing', {
					title    = 'Garderoba - załóż ubranie',
					align    = 'left',
					elements = elements
				}, function(data2, menu2)
					TriggerEvent('skinchanger:getSkin', function(skin)
						ESX.TriggerServerCallback('pz_property:getPlayerOutfit', function(clothes)
							TriggerEvent('skinchanger:loadClothes', skin, clothes)
							TriggerEvent('pz_skin:setLastSkin', skin)

							TriggerEvent('skinchanger:getSkin', function(skin)
								TriggerServerEvent('pz_skin:save', skin)
							end)
						end, data2.current.value)
					end)
				end, function(data2, menu2)
					menu2.close()
				end)
			end)

		elseif data.current.value == 'remove_cloth' then

			ESX.TriggerServerCallback('pz_property:getPlayerDressing', function(dressing)
				local elements = {}

				for i=1, #dressing, 1 do
					table.insert(elements, {
						label = dressing[i],
						value = i
					})
				end

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'remove_cloth', {
					title    = 'Garderoba - usuń ubranie',
					align    = 'left',
					elements = elements
				}, function(data2, menu2)
					menu2.close()
					TriggerServerEvent('pz_property:removeOutfit', data2.current.value)
					ESX.ShowNotification('Usunięto ubranie')
				end, function(data2, menu2)
					menu2.close()
				end)
			end)
		end

	end, function(data, menu)
		menu.close()
	end)
end

function spawnLoyalesVehicle()
	local pedCoords = GetEntityCoords(ped)
	local area = {x = Config.CarSpawnPosition["x"], y = Config.CarSpawnPosition["y"], z = Config.CarSpawnPosition["z"]}
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if GetClosestVehicle(pedCoords, 20.0,0, 70) == 0.0 and ESX.Game.IsSpawnPointClear(area, 7) then
		if closestPlayer ~= nil and closestDistance > 3.0 then	
			if not VehicleIsSpawning then
				local playerPed = GetPlayerPed(-1)
				local model = 'gburrito2'
				ESX.Game.SpawnVehicle(model, {
					x = Config.CarSpawnPosition["x"],
					y = Config.CarSpawnPosition["y"],
					z = Config.CarSpawnPosition["z"]	
					}, 0.0, function(vehicle)
					TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
					local props = {
						modEngine       = 2,
						modBrakes       = 2,
						modTransmission = 2,
						modSuspension   = 3,
						modTurbo        = true,
					}

					ESX.Game.SetVehicleProperties(vehicle, props)		
				end)
				VehicleIsSpawning = true
			end
				VehicleIsSpawning = false
		else
			ESX.ShowHelpNotification('~r~W pobliżu ktoś stoi, zwariowałeś?!')	
		end
	end
end
function teleportToRandomBunkerExit(playerPed)
	local bunkers = 0
	for id ,bunkerID in ipairs(Config.Bunkers) do
		bunkers = id
	end
	local randomValue = math.random(1, bunkers)
	SetPedCoordsKeepVehicle(playerPed, Config.Bunkers[randomValue]["x"], Config.Bunkers[randomValue]["y"], Config.Bunkers[randomValue]["z"])
	createGPSToRandomWeaponShop(playerPed)
end

function createGPSToRandomWeaponShop(playerPed)
	local weaponShops = 0
	for id ,weaponShopID in ipairs(Config.WeaponShopsCarStop) do
		weaponShops = id
	end
	local randomValue = math.random(1, weaponShops)
	
	SetTimeout(500, function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	local players = ESX.Game.GetPlayersInArea(coords, 2.5)
	for k, id in ipairs(players) do
		local xPlayer = GetPlayerServerId(id)
		TriggerServerEvent('pz-loyalesbunker:createGPSRouteAndMarkersForSell', xPlayer, randomValue)
	end		
	end)
end

RegisterNetEvent("pz-loyalesbunker:throwGPSAndOtherDirectlyToPlayer")
AddEventHandler("pz-loyalesbunker:throwGPSAndOtherDirectlyToPlayer", function(randomValue)
	print('poszlo')
	SetNewWaypoint(Config.WeaponShopsCarStop[randomValue]["x"], Config.WeaponShopsCarStop[randomValue]["y"])	
	local blipInfo = GetFirstBlipInfoId(8)
	if (blipInfo ~= nil and blipInfo ~= 0) then
		PlayerData.delivering = true
		BlipCoords = {x = Config.WeaponShopsCarStop[randomValue]["x"], y = Config.WeaponShopsCarStop[randomValue]["y"], z = Config.WeaponShopsCarStop[randomValue]["z"]}
		
		Citizen.CreateThread(function()
			while PlayerData.delivering do
				local sleepThread = 500			
				local coords = GetEntityCoords(GetPlayerPed(-1))
				local dist = GetDistanceBetweenCoords(coords, BlipCoords.x, BlipCoords.y, BlipCoords.z)
				if dist < 100.0 then
					sleepThread = 5
					DrawMarker(1, BlipCoords.x, BlipCoords.y, BlipCoords.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 5.0, 5.0, 1.0, 255, 33, 27, 100, false, true, 2, false, false, false, false)
						if dist < 2.0 then
							PlayerData.isNearDeliveryMarker = true	
							if IsControlJustPressed(0, 38) then			
								OpenSellMenu()					
							end
						end	
						if PlayerData.isNearDeliveryMarker then
							if dist > 40.0 then
								PlayerData.delivering = false
								BlipCoords = {}	
							end
						end
				end
			Citizen.Wait(sleepThread)			
			end
		end)		
	end
end)

function OpenSellMenu()
	ESX.TriggerServerCallback("pz_inventoryhud:getPlayerInventory", function(data)
		items = {}
		inventory = data.inventory
									
		if inventory ~= nil then
			for key, value in pairs(inventory) do
				if inventory[key].count <= 0 then
					inventory[key] = nil
				else
					inventory[key].type = "item_standard" 
					for k, id in ipairs(Config.WeaponNames) do
						if inventory[key].label == id.label then
						table.insert(items, { ["label"] = inventory[key].label .. " " .. inventory[key].count .. "x", ["value"] = id.itemName})	
						break
						end
					end	
				end
			end
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'magazine_menu_sell', {
			title    = 'Sprzedaż broni',
			align    = 'bottom-left',
			elements = items
		}, 
		function(data2, menu2)
												
			TriggerServerEvent('pz-loyalesbunker:sellWeaponInShop', data2.current.value)
			OpenSellMenu()
		end, function(data2, menu2)
		menu2.close()							
		end)	
	end
	end, GetPlayerServerId(PlayerId()))		
end

function OpenIllegalSellMenu()
	ESX.TriggerServerCallback("pz_inventoryhud:getPlayerInventory", function(data)
		items = {}
		inventory = data.inventory
									
		if inventory ~= nil then
			for key, value in pairs(inventory) do
				if inventory[key].count <= 0 then
					inventory[key] = nil
				else
					inventory[key].type = "item_standard" 
					for k, id in ipairs(Config.WeaponNames) do
						if inventory[key].label == id.label then
						table.insert(items, { ["label"] = inventory[key].label .. " " .. inventory[key].count .. "x", ["value"] = id.itemName})	
						break
						end
					end	
				end
			end
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'magazine_illegal_menu_sell', {
			title    = 'Nielegalna sprzedaż broni',
			align    = 'bottom-left',
			elements = items
		}, 
		function(data2, menu2)
			TriggerServerEvent('pz-loyalesbunker:sellWeaponInIllegalShop', data2.current.value)
			OpenIllegalSellMenu()
		end, function(data2, menu2)
		menu2.close()							
		end)	
	end
	end, GetPlayerServerId(PlayerId()))		
end

function TeleportPlayerToFactory()
	ESX.TriggerServerCallback("pz-loyalesbunker:DoesPedHaveMagneticCard", function(valid)
		if valid then
			ESX.ShowNotification('~g~Identyfikacja przebiegła pomyślnie.')	
			SetTimeout(1400, function()
				Teleport(Config.TeleportPosition)
			end)
		else
			ESX.ShowNotification('~r~Nie~w~ posiadasz karty magnetycznej.')
		end
	end)
end

function CreateCard()
	TriggerServerEvent('pz-loyalesbunker:createCard')
end
RegisterCommand("tplo", function(source)
    TeleportToWaypoint()
end)

TeleportToWaypoint = function()
	local TeleportCoords = Config.TeleportPosition
	Teleport(TeleportCoords)	
end