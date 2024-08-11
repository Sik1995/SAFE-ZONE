-- Locals
local gznotifIn = false
local gznotifOut = false
local rznotifIn = false
local rznotifOut = false
local gzclosestZone = 1 
local closestZone = 1

-- Green Zone Threads
local zones = {
	{ ['x'] = 191.27, ['y'] = -734.74, ['z'] = 33.87}, -- einreise 3   
	{ ['x'] = 228.00, ['y'] = -660.20, ['z'] = 38.34}, -- einreise 3   
	{ ['x'] = 226.2, ['y'] = -788.77, ['z'] = 30.7}, -- einreise 3  
	{ ['x'] = 310.99, ['y'] = -588.33, ['z'] = 43.28 }, -- einreise 1  
	{ ['x'] = 132.4574, ['y'] = -1039.8812, ['z'] = 22.9602 },
	{ ['x'] = -1191.1238, ['y'] = -892.1834, ['z'] = 13.8862 }, 
	--{ ['x'] = -34.4191, ['y'] = -1823.9711, ['z'] = 26.1909 },
	--{ ['x'] = -1003.8660, ['y'] = -287.3893, ['z'] = 44.7973 },
	{ ['x'] = -1033.0851, ['y'] = -2727.5347, ['z'] = 20.1796 }, 
	{ ['x'] = 396.31, ['y'] = -4.64, ['z'] = 91.94 } -- einreise 2 
}

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(3)
	end
	
	while true do
		local playerPed = GetPlayerPed(-1)
		local x, y, z = table.unpack(GetEntityCoords(playerPed, true))
		local minDistance = 100000
		for i = 1, #zones, 1 do
			dist = Vdist(zones[i].x, zones[i].y, zones[i].z, x, y, z)
			if dist < minDistance then
				minDistance = dist
				gzclosestZone = i
			end
		end
		Citizen.Wait(15000)
	end
end)

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end
	
	while true do
		Citizen.Wait(3)
		local player = GetPlayerPed(-1)
		local x,y,z = table.unpack(GetEntityCoords(player, true))
		local dist = Vdist(zones[gzclosestZone].x, zones[gzclosestZone].y, zones[gzclosestZone].z, x, y, z)
		local sleep = true
	
		if dist <= 60.0 then 
			if not gznotifIn then																			 
				NetworkSetFriendlyFireOption(false)
				ClearPlayerWantedLevel(PlayerId())
				SetCurrentPedWeapon(player,GetHashKey("WEAPON_UNARMED"),true)
				InGreenZone()
				TriggerEvent("cs_notify-right", "Safezone", "Du hast die Safezone betreten", 6000)
				gznotifIn = true
				gznotifOut = false
			end
		else
			if not gznotifOut then
				NetworkSetFriendlyFireOption(true)
				LeaveGreenZone()
				TriggerEvent("cs_notify-right", "Safezone", "Du hast die Safezone verlassen", 6000) 
				gznotifOut = true
				gznotifIn = false
			end
		end
		if gznotifIn then
			sleep = false
			DisableControlAction(2, 37, true) -- disable weapon wheel (Tab)
			DisablePlayerFiring(player,true) -- Disables firing all together if they somehow bypass inzone Mouse Disable
      		DisableControlAction(0, 106, true) -- Disable in-game mouse controls
			DisableControlAction(0,24,true) -- disable attack
			DisableControlAction(0,25,true) -- disable aim
			DisableControlAction(0,47,true) -- disable weapon
			DisableControlAction(0,58,true) -- disable weapon
			DisableControlAction(0,263,true) -- disable melee
			DisableControlAction(0,264,true) -- disable melee
			DisableControlAction(0,257,true) -- disable melee
			DisableControlAction(0,140,true) -- disable melee
			DisableControlAction(0,141,true) -- disable melee
			DisableControlAction(0,142,true) -- disable melee
			DisableControlAction(0,143,true) -- disable melee
			if IsDisabledControlJustPressed(2, 37) then --if Tab is pressed, send error message
				SetCurrentPedWeapon(player,GetHashKey("WEAPON_UNARMED"),true) -- if tab is pressed it will set them to unarmed (this is to cover the vehicle glitch until I sort that all out)
			end
			if IsDisabledControlJustPressed(0, 106) then --if LeftClick is pressed, send error message
				SetCurrentPedWeapon(player,GetHashKey("WEAPON_UNARMED"),true) -- If they click it will set them to unarmed
			end
		end

		if (sleep == true) then
			Citizen.Wait(1250)
		end
	end
end)

local redZones = {} -- Initialize as an empty table if it's not already initialized elsewhere

CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(3)
	end
	while true do
		local playerPed = PlayerPedId()
		local x, y, z = table.unpack(GetEntityCoords(playerPed, true))
		local minDistance = 100000
		for i = 1, #redZones, 1 do
			rzdist = Vdist(redZones[i].x, redZones[i].y, redZones[i].z, x, y, z)
			if rzdist < minDistance then
				minDistance = rzdist
				closestZone = i
			end
		end
		Citizen.Wait(15000)
	end
end)


-- Functions
function InGreenZone()
	SendNUIMessage({
		action = 'show'
	})
end

function LeaveGreenZone()
	SendNUIMessage({
		action = 'hide'
	})
end

function InRedZone()
	SendNUIMessage({
		action = 'show1'
	})
end

function LeaveRedZone()
	SendNUIMessage({
		action = 'hide1'
	})
end
