ESX = nil

local npc = false

local PlayerData = {}

local inProgress = false
local RENTSpawned = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer

end)

----------------------------- BT TARGET -------------------------

Citizen.CreateThread(function()
	while true do
	Wait(1000)
		if refreshRENT then
	        if DoesEntityExist(bikeRENT) then
	        exports['bt-target']:AddEntityZone('bikeRENT', bikeRENT, {
	        name="bikeRENT",
	        debugPoly=false,
	        useZ = true
	          }, {
	          options = {
	            {
	            event = "nh-context:openrentmenu",
	            icon = "fas fa-bicycle",
	            label = "Huren / inleveren van een fiets",
	            },
	            --{
	            --event = "ESX.Game.DeleteVehicle(bikehash)",
	            --icon = "fas fa-campground",
	            --label = "Fiets terugbrengen",
	            --},
	          },
	            job = {"all"},
	            distance = 2.0
	          })

	        refreshRENT = false
	        end
	    end
	end
end)


-- Spawn Boss NPC When you get close, delete when you leave

Citizen.CreateThread(function()
    while true do
      Citizen.Wait(1000)
        local pedCoords = GetEntityCoords(GetPlayerPed(-1)) 
        local RENTCoords = vector3(-252.98000, -970.8800, 31.222241 - 1)
        local dst = #(RENTCoords - pedCoords)
        if dst < 200 and RENTSpawned == false then
          TriggerEvent('gb-bikerental:spawnbikeRENT',RENTCoords, -124.26900)
          RENTSpawned = true
          refreshRENT = true
        end
        if dst >= 201  then
          if DoesEntityExist(npc) then
            RENTSpawned = false
            DeletePed(bikeRENT)
          end         
          
          
        end
    end
  end)

  RegisterNetEvent('gb-bikerental:spawnbikeRENT')
AddEventHandler('gb-bikerental:spawnbikeRENT',function(coords, heading)
  local hash = GetHashKey('a_m_m_skater_01')
  if not HasModelLoaded(hash) then
    RequestModel(hash)
    Wait(10)
  end
  while not HasModelLoaded(hash) do 
    Wait(10)
  end
  bikeRENT = CreatePed(5, hash, coords, 165.19, false, false)
  FreezeEntityPosition(bikeRENT, true)
  SetEntityInvincible(bikeRENT, true)
  SetBlockingOfNonTemporaryEvents(bikeRENT, true)

end)

-----------------bikes -------------------------

RegisterNetEvent('gb-bikerental:rentFIXTER')
AddEventHandler('gb-bikerental:rentFIXTER',function()
local ped = GetPlayerPed(-1)
local bikeCoords = vector3(-250.48000, -968.28700, 31.22713 - 1)
local bikeHeading = 250.74420
local bikeHash = 'fixter'
RequestModel(bikeHash)
while not HasModelLoaded(bikeHash) do Citizen.Wait(0) end
if DoesEntityExist(vehc) then
  vehHealth = GetVehicleEngineHealth(vehc)
  if vehHealth >= 600 then
    exports['mythic_notify']:DoHudText('success', 'Bedankt voor het terugbrengen.')
  else
    exports['mythic_notify']:DoHudText('error', 'Je hebt mijn fiets kapot gemaakt! Dit kost je wat.')
    TriggerServerEvent('gb-bikerental:takeMoney')
  end
  ESX.Game.DeleteVehicle(vehc)
else
  vehc = CreateVehicle(bikeHash,bikeCoords,bikeHeading,true, true)
  TriggerServerEvent("esx:bike:pay", Config.PriceFixter) 
  exports['mythic_notify']:SendAlert('inform', 'Je hebt een fixter gehuurd voor €300!')
  end

end)

RegisterNetEvent('gb-bikerental:rentSCORCHER')
AddEventHandler('gb-bikerental:rentSCORCHER',function()
local ped = GetPlayerPed(-1)
local bikeCoords = vector3(-248.48000, -964.28700, 31.22713 - 1)
local bikeHeading = 250.74420
local bikeHash = 'scorcher'
RequestModel(bikeHash)
while not HasModelLoaded(bikeHash) do Citizen.Wait(0) end
if DoesEntityExist(vehc) then
  vehHealth = GetVehicleEngineHealth(vehc)
  if vehHealth >= 600 then
    exports['mythic_notify']:DoHudText('success', 'Bedankt voor het terugbrengen.')
  else
    exports['mythic_notify']:DoHudText('error', 'Je hebt mijn fiets kapot gemaakt! Dit kost je wat.')
    TriggerServerEvent('gb-bikerental:takeMoney')
  end
  ESX.Game.DeleteVehicle(vehc)
else
  vehc = CreateVehicle(bikeHash,bikeCoords,bikeHeading,true, true)
  TriggerServerEvent("esx:bike:pay", Config.PriceScorcher) 
  exports['mythic_notify']:SendAlert('inform', 'Je hebt een scorcher gehuurd voor €300!')
end

end)

RegisterNetEvent('gb-bikerental:rentCRUISER')
AddEventHandler('gb-bikerental:rentCRUISER',function()
local ped = GetPlayerPed(-1)
local bikeCoords = vector3(-246.48000, -959.28700, 31.22713 - 1)
local bikeHeading = 250.74420
local bikeHash = 'cruiser'
RequestModel(bikeHash)
while not HasModelLoaded(bikeHash) do Citizen.Wait(0) end
if DoesEntityExist(vehc) then
  vehHealth = GetVehicleEngineHealth(vehc)
  if vehHealth >= 600 then
    exports['mythic_notify']:DoHudText('success', 'Bedankt voor het terugbrengen.')
  else
    exports['mythic_notify']:DoHudText('error', 'Je hebt mijn fiets kapot gemaakt! Dit kost je wat.')
    TriggerServerEvent('gb-bikerental:takeMoney')
  end
  ESX.Game.DeleteVehicle(vehc)
else
  vehc = CreateVehicle(bikeHash,bikeCoords,bikeHeading,true, true)
  TriggerServerEvent("esx:bike:pay", Config.PriceCruiser) 
  exports['mythic_notify']:SendAlert('inform', 'Je hebt een cruiser gehuurd voor €300!')
end

end)

----------------menu-------------------------

RegisterNetEvent('nh-context:openrentmenu', function()
    TriggerEvent('nh-context:sendMenu', {
        {
            id = 1,
            header = "Fietsen Verhuur",
            txt = ""
        },
        {
            id = 2,
            header = "Huren / inleveren Fixter",
            txt = "Prijs: €300,- contant",
            params = {
                event = "gb-bikerental:rentFIXTER",
                args = {
                    number = 1,
                    id = 2
                }
            }
        },
        {
            id = 3,
            header = "Huren / inleveren Scorcher",
            txt = "Prijs: €300,- contant",
            params = {
                event = "gb-bikerental:rentSCORCHER",
                args = {
                    number = 1,
                    id = 3
                }
            }
        },
        {
            id = 4,
            header = "Huren / inleveren Cruiser",
            txt = "Prijs: €300,- contant",
            params = {
                event = "gb-bikerental:rentCRUISER",
                args = {
                    number = 1,
                    id = 4
                }
            }
        },

    })
end)

---------------------------------------------Fiets Oppakken----------------------------------------
RegisterNetEvent('pickup:bike')
AddEventHandler('pickup:bike', function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)
    local bone = GetPedBoneIndex(playerPed, 0xE5F3)
    local bike = false

    if GetEntityModel(vehicle) == GetHashKey("bmx") or GetEntityModel(vehicle) == GetHashKey("scorcher") or GetEntityModel(vehicle) == GetHashKey("cruiser") or GetEntityModel(vehicle) == GetHashKey("fixter") or GetEntityModel(vehicle) == GetHashKey("tribike") or GetEntityModel(vehicle) == GetHashKey("tribike2") or GetEntityModel(vehicle) == GetHashKey("tribike3") then

    AttachEntityToEntity(vehicle, playerPed, bone, 0.0, 0.24, 0.10, 340.0, 330.0, 330.0, true, true, false, true, 1, true)
    exports['mythic_notify']:SendAlert('inform', 'Druk op G om de fiets los te laten.', 5000)

    RequestAnimDict("anim@heists@box_carry@")
    while (not HasAnimDictLoaded("anim@heists@box_carry@")) do Citizen.Wait(0) end
    TaskPlayAnim(playerPed, "anim@heists@box_carry@", "idle", 2.0, 2.0, 50000000, 51, 0, false, false, false)
    bike = true

    RegisterCommand('dropbike', function()
        if IsEntityAttached(vehicle) then
        DetachEntity(vehicle, nil, nil)
        SetVehicleOnGroundProperly(vehicle)
        ClearPedTasksImmediately(playerPed)
        bike = false
        end
    end, false)

        RegisterKeyMapping('dropbike', 'Drop Bike', 'keyboard', 'g')

                Citizen.CreateThread(function()
                while true do
                Citizen.Wait(0)
                if bike and IsEntityPlayingAnim(playerPed, "anim@heists@box_carry@", "idle", 3) ~= 1 then
                    RequestAnimDict("anim@heists@box_carry@")
                    while (not HasAnimDictLoaded("anim@heists@box_carry@")) do Citizen.Wait(0) end
                    TaskPlayAnim(playerPed, "anim@heists@box_carry@", "idle", 2.0, 2.0, 50000000, 51, 0, false, false, false)
                    if not IsEntityAttachedToEntity(playerPed, vehicle) then
                        bike = false
                        ClearPedTasksImmediately(playerPed)
                    end
                end
            end
        end)
    end
end)