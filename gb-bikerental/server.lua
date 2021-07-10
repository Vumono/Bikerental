ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("esx:bike:pay")
AddEventHandler("esx:bike:pay", function(money)
    local _source = source	
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeMoney(money)
end)

Citizen.CreateThread(function()
	Citizen.Wait(5000)
	local ver = "1.0.0"
	print("Vumon's bike RENT started"..ver)
end)

RegisterServerEvent('gb-bikerental:takeMoney')
AddEventHandler('gb-bikerental:takeMoney', function()
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeAccountMoney('bank', Config.FietsDMGfee)
end)