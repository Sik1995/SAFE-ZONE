QBCore = nil

TriggerEvent('QBCore:getSharedObject', function(object) QBCore = object end)

function getIdentity(identifier, callback)
	MySQL.Async.fetchAll("SELECT `firstname`, `lastname`, `dateofbirth`, `sex`, `height` FROM `users` WHERE `identifier` = @identifier", {
		['@identifier'] = identifier
	}, function(result)
		if result[1] then
			if result[1].firstname ~= nil then
				local data = {
					identifier = identifier,
					firstname = result[1].firstname,
					lastname = result[1].lastname,
					dateofbirth	= result[1].dateofbirth,
					sex = result[1].sex,
					height = result[1].height
				}
	
				callback(data)
			else
				local data = {
					identifier = '',
					firstname = '',
					lastname = '',
					dateofbirth	= '',
					sex	= '',
					height = ''
				}
				
				callback(data)
			end
		else
			local data = {
				identifier = '',
				firstname = '',
				lastname = '',
				dateofbirth	= '',
				sex	= '', --trans
				height = ''
			}
			
			callback(data)
		end
	end)
end

function setIdentity(identifier, data, callback)
	MySQL.Async.execute("UPDATE `users` SET `firstname` = @firstname, `lastname` = @lastname, `dateofbirth` = @dateofbirth, `sex` = @sex, `height` = @height WHERE identifier = @identifier", {
		['@identifier'] = identifier,
		['@firstname'] = data.firstname,
		['@lastname'] = data.lastname,
		['@dateofbirth'] = data.dateofbirth,
		['@sex'] = data.sex,
		['@height'] = data.height
	}, function(done)
		if callback then
			callback(true)
		end
	end)
end

RegisterServerEvent('cv_identity:setIdentity')
AddEventHandler('cv_identity:setIdentity', function(data)
	local source = source
	local xPlayer = QBCore.GetPlayerFromId(source)

	getIdentity(xPlayer.identifier, function(data123)
		if data123.firstname == '' or data123.firstname == nil then
			setIdentity(xPlayer.identifier, data, function(callback)
				
			end)
		end
	end)
end)

AddEventHandler('QBCore:playerLoaded', function(playerId, xPlayer)
	Citizen.Wait(5000)
	
	getIdentity(xPlayer.identifier, function(data)
		if data.firstname == '' or data.firstname == nil then
			TriggerClientEvent('cv_identity:showIdentity', playerId)
		end
	end)
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Citizen.Wait(4500)

		local xPlayers = QBCore.GetPlayers()
		for i=1, #xPlayers, 1 do
		
			local xPlayer = QBCore.GetPlayerFromId(xPlayers[i])
			
			getIdentity(xPlayer.identifier, function(data)
				if data.firstname == '' or data.lastname == nil then
					TriggerClientEvent('cv_identity:showIdentity', xPlayer.source)
				end
			end)
		end
	end
end)

RegisterCommand('register', function(source, args, rawCommand)
	local xPlayer = QBCore.GetPlayerFromId(source)

	getIdentity(xPlayer.identifier, function(data)
		if data.firstname == '' then
			TriggerClientEvent('cv_identity:showIdentity', source)
		end
	end)
end)

RegisterCommand('resetchar', function(source, args, rawCommand)
	local xPlayer = QBCore.GetPlayerFromId(source)
	local xTarget = QBCore.GetPlayerFromId(tonumber(args[1]))

	if xPlayer.getGroup() ~= 'user' then
		if xTarget then
			local data = {
				firstname = '',
				lastname = '',
				dateofbirth = '',
				sex = '',
				height = 0
			}

			setIdentity(xTarget.identifier, data, function(callback)
				if callback then
					TriggerClientEvent('cv_identity:showIdentity', xTarget.source)
				end
			end)
		end
	end
end)