local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
func = Tunnel.getInterface("vrp_yorkcaixa")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local andamento = false
local segundos = 0
local t_roubo = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- GERANDO LOCAL DO ROUBO
-----------------------------------------------------------------------------------------------------------------------------------------
local locais = {
	{ ['id'] = 1, ['x'] = 119.43, ['y'] = -883.59, ['z'] = 31.13, ['h'] = 71.64 },
	{ ['id'] = 2, ['x'] = -1315.85, ['y'] = -835.08, ['z'] = 16.97, ['h'] = 307.95 },
	{ ['id'] = 3, ['x'] = 285.36, ['y'] = 143.75, ['z'] = 104.18, ['h'] = 162.61 },
	{ ['id'] = 4, ['x'] = 1138.75, ['y'] = -468.7, ['z'] = 66.74, ['h'] = 70.68 },
	{ ['id'] = 5, ['x'] = 1077.70, ['y'] = -776.54, ['z'] = 58.24, ['h'] = 182.0 }, 
	{ ['id'] = 6, ['x'] = -710.03, ['y'] = -818.90, ['z'] = 23.72, ['h'] = 0.0 },
	{ ['id'] = 7, ['x'] = -821.63, ['y'] = -1081.89, ['z'] = 11.13, ['h'] = 31.0 },
	{ ['id'] = 8, ['x'] = -1409.75, ['y'] = -100.44, ['z'] = 52.38, ['h'] = 107.0 },
	{ ['id'] = 9, ['x'] = -846.29, ['y'] = -341.28, ['z'] = 38.68, ['h'] = 116.0 },
	{ ['id'] = 10, ['x'] = -2072.36, ['y'] = -317.29, ['z'] = 13.31, ['h'] = 260.0 },
	{ ['id'] = 11, ['x'] = -526.64, ['y'] = -1222.97, ['z'] = 18.45, ['h'] = 153.0 },
	{ ['id'] = 12, ['x'] = -254.41, ['y'] = -692.46, ['z'] = 33.60, ['h'] = 159.0 },
	{ ['id'] = 13, ['x'] = -283.34, ['y'] = 6225.71, ['z'] = 31.5, ['h'] = 313.90 },
	{ ['id'] = 14, ['x'] = 155.6, ['y'] = 6642.58, ['z'] = 31.61, ['h'] = 313.90 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- INICIO/CANCELAR
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local ped = PlayerPedId()
		local x,y,z = GetEntityCoords(ped)
		if GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_UNARMED") and not IsPedInAnyVehicle(ped) then
			for k,v in pairs(locais) do
				if Vdist(v.x,v.y,v.z,x,y,z) <= 1 and not andamento then
					drawTxt("PRESSIONE  ~r~G~w~  PARA INICIAR O ROUBO",4,0.5,0.93,0.50,255,255,255,180)
					if IsControlJustPressed(0,47) and func.checkPermission() then
						if func.checkItem() then
							if func.checkRobbery(v.x,v.y,v.z) then
								func.getItem()
								if v.id == 1 then
									t_roubo = 25
								elseif v.id == 2 or v.id == 3 or v.id == 8 then
									t_roubo = 39
								elseif v.id == 4 or v.id == 9 then
									t_roubo = 35
								elseif v.id == 5 or v.id == 6 then
									t_roubo = 33
								elseif v.id == 7 then
									t_roubo = 55
								elseif v.id == 10 then
									t_roubo = 60
								elseif v.id == 11 then
									t_roubo = 43
								elseif v.id == 12 then
									t_roubo = 27 
								elseif v.id == 13 then
									t_roubo = 45
								elseif v.id == 14 then
									t_roubo = 50
								end
								local distance = GetDistanceBetweenCoords(v.x, v.y, v.z, x,y,z,true)
								if distance <= 3 then
									TaskGoStraightToCoord(ped, v.x,v.y,v.z,1.0, 100000, v.h, 2.0)
									if distance <= 0.3 then
									  ClearPedTasks(ped)
									  SetEntityHeading(ped, v.h)
									end
								end
								local ped = PlayerPedId()
								local thermal_hash = GetHashKey("hei_prop_heist_thermite_flash")
								local bagHash4 = GetHashKey('p_ld_heist_bag_s_pro_o')
								local coords = GetEntityCoords(ped)
								loadModel(thermal_hash)
								Wait(10)
								loadModel(bagHash4)
								Wait(10)

								thermalentity = CreateObject(thermal_hash, (v.x+v.y+v.z)-20, true, true)
								local bagProp4 = CreateObject(bagHash4, coords-20, true, false)
								SetEntityAsMissionEntity(thermalentity, true, true)
								SetEntityAsMissionEntity(bagProp4, true, true)
								termitacolocando = true
								local boneIndexf1 = GetPedBoneIndex(PlayerPedId(), 28422)
								local bagIndex1 = GetPedBoneIndex(PlayerPedId(), 57005)
								Wait(500)
								SetPedComponentVariation(PlayerPedId(), 5, 0, 0, 0)
								AttachEntityToEntity(thermalentity, PlayerPedId(), boneIndexf1, 0.0, 0.0, 0.0, 180.0, 180.0, 0, 1, 1, 0, 1, 1, 1)
								AttachEntityToEntity(bagProp4, PlayerPedId(), bagIndex1, 0.3, -0.25, -0.3, 300.0, 200.0, 300.0, true, true, false, true, 1, true)


								RequestAnimDict('anim@heists@ornate_bank@thermal_charge')
								while not HasAnimDictLoaded('anim@heists@ornate_bank@thermal_charge') do
									Wait(100)
								end
								vRP._playAnim(false,{{'anim@heists@ornate_bank@thermal_charge','thermal_charge'}},false)


								Wait(2500)
								DetachEntity(bagProp4, 1, 1)
								FreezeEntityPosition(bagProp4, true)
								Wait(2500)
								FreezeEntityPosition(bagProp4, false)
								AttachEntityToEntity(bagProp4, PlayerPedId(), bagIndex1, 0.3, -0.25, -0.3, 300.0, 200.0, 300.0, true, true, false, true, 1, true)
								Wait(1000)
								DeleteEntity(bagProp4)
								SetPedComponentVariation(PlayerPedId(), 5, 40, 0, 0)
								DeleteEntity(thermalentity)
								ClearPedTasks(player)
								TriggerEvent("Notify","importante","Você plantou a bomba, cuidado...")
								contador_id = 0		
								while contador_id <= t_roubo do
									if t_roubo == 25 then
										TriggerEvent("vrp_sound:distance", source, 0.8, 'bomb_25', 0.5)
										Wait(25000)
										contador_id = t_roubo + 1
									elseif t_roubo == 39 then
										if contador_id <= 14 then
											TriggerEvent("vrp_sound:distance", source, 0.8, 'bomb_25', 0.5)
											Wait(1000)
										else
											TriggerEvent("vrp_sound:distance", source, 0.8, 'bomb_25', 0.5)
											Wait(25000)
											contador_id = t_roubo + 1
										end	
									elseif t_roubo == 35 then
										if contador_id <= 10 then
											TriggerEvent("vrp_sound:distance", source, 0.8, 'bomb_25', 0.5)
											Wait(1000)
										else
											TriggerEvent("vrp_sound:distance", source, 0.8, 'bomb_25', 0.5)
											Wait(25000)
											contador_id = t_roubo + 1
										end	
									elseif t_roubo == 33 then
										if contador_id <= 8 then
											TriggerEvent("vrp_sound:distance", source, 0.8, 'bomb_25', 0.5)
											Wait(1000)
										else
											TriggerEvent("vrp_sound:distance", source, 0.8, 'bomb_25', 0.5)
											Wait(25000)
											contador_id = t_roubo + 1
										end	
									elseif t_roubo == 55 then
										if contador_id <= 20 then
											TriggerEvent("vrp_sound:distance", source, 0.8, 'bomb_25', 0.5)
											Wait(1000)
										else
											TriggerEvent("vrp_sound:distance", source, 0.8, 'bomb_25', 0.5)
											Wait(25000)
											contador_id = t_roubo + 1
										end
									elseif t_roubo == 60 then
										if contador_id <= 35 then
											TriggerEvent("vrp_sound:distance", source, 0.8, 'bomb_25', 0.5)
											Wait(1000)
										else
											TriggerEvent("vrp_sound:distance", source, 0.8, 'bomb_25', 0.5)
											Wait(25000)
											contador_id = t_roubo + 1
										end
									elseif t_roubo == 43 then
										if contador_id <= 18 then
											TriggerEvent("vrp_sound:distance", source, 0.8, 'bomb_25', 0.5)  
											Wait(1000)
										else
											TriggerEvent("vrp_sound:distance", source, 0.8, 'bomb_25', 0.5)
											Wait(25000)
											contador_id = t_roubo + 1
										end
									elseif t_roubo == 27 then
										if contador_id <= 10 then
											TriggerEvent("vrp_sound:distance", source, 0.8, 'bomb_25', 0.5)
											Wait(1000)
										else
											TriggerEvent("vrp_sound:distance", source, 0.8, 'bomb_25', 0.5)
											Wait(25000)
											contador_id = t_roubo + 1
										end
									elseif t_roubo == 45 then
										if contador_id <= 20 then
											TriggerEvent("vrp_sound:distance", source, 0.8, 'bomb_25', 0.5)
											Wait(1000)
										else
											TriggerEvent("vrp_sound:distance", source, 0.8, 'bomb_25', 0.5)
											Wait(25000)
											contador_id = t_roubo + 1
										end
									elseif t_roubo == 50 then
										if contador_id <= 25 then
											TriggerEvent("vrp_sound:distance", source, 0.8, 'bomb_25', 0.5)
											Wait(1000)
										else
											TriggerEvent("vrp_sound:distance", source, 0.8, 'bomb_25', 0.5)
											Wait(25000)
											contador_id = t_roubo + 1
										end
									end
									contador_id = contador_id + 1
								end
								AddExplosion(v.x,v.y,v.z,2 , 100.0, true, false, true)
								local dinheiro_prop = "hei_prop_heist_cash_pile"
								RequestModel(dinheiro_prop)
								while not HasModelLoaded(dinheiro_prop) do
									Citizen.Wait(10)
								end
								if not HasModelLoaded(dinheiro_prop) then
									SetModelAsNoLongerNeeded(dinheiro_prop)
								else
									SetModelAsNoLongerNeeded(dinheiro_prop)
									contador = 4
									contador_dinheiro_spawn = 4
									local boneIndex = GetPedBoneIndex(PlayerPedId(), 57005)
									while contador >= 0 do 
										Citizen.Wait(10)
										local ped = PlayerPedId()
										x,y,z = table.unpack(GetEntityCoords(ped))
										distance2 = GetDistanceBetweenCoords(v.x,v.y,v.z,x,y,z,true)
										if contador_dinheiro_spawn >= 0 then
											dinheiro_object = CreateObjectNoOffset(dinheiro_prop, v.x, v.y, v.z, 1, 0, 1)
											x2,y2,z2 = table.unpack(GetEntityCoords(dinheiro_object))
											contador_dinheiro_spawn = contador_dinheiro_spawn - 1
										end
										if distance2 <= 1 then
											DrawText3Ds(x2,y2,z2-0.8,"~b~[G] ~w~PEGAR")
											if IsControlJustPressed(0,47) and not IsPedInAnyVehicle(ped) and not IsEntityDead(ped) then
												vRP._playAnim(false,{{'pickup_object','pickup_low'}},false)
												Wait(1000)
												SetEntityVisible(dinheiro_object, true)
												func.giveItens()
												AttachEntityToEntity(dinheiro_object, PlayerPedId(), boneIndex, 0.125, 0.0, -0.05, 360.0, 150.0, 360.0, true, true, false, true, 1, true)
												Wait(800)
												SetEntityVisible(dinheiro_object, false)
												contador = contador - 1
											end
										elseif Vdist(v.x,v.y,v.z,x,y,z) > 15 then
											func.cancelRobbery()
											TriggerEvent("Notify","negado","Você fugiu do roubo e deixou tudo para trás.")
											contador = -1
										end
									end
									DeleteEntity(dinheiro_object)
								end
							end
						else
							TriggerEvent("Notify","negado","Você não possui uma C4.")
						end
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INICIADO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("iniciandocaixaeletronico")
AddEventHandler("iniciandocaixaeletronico",function(x,y,z,secs,head)
	segundos = secs
	andamento = true
	SetEntityHeading(PlayerPedId(),head)
	SetEntityCoords(PlayerPedId(),x,y,z-1,false,false,false,false)
	SetPedComponentVariation(PlayerPedId(),5,45,0,2)
	TriggerEvent('cancelando',true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONTAGEM
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if andamento then
			segundos = segundos - 1
			if segundos <= 0 then
				andamento = false
				ClearPedTasks(PlayerPedId())
				TriggerEvent('cancelando',false)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end


function DrawText3Ds(x,y,z,text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.34, 0.34)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.001+ factor, 0.028, 0, 0, 0, 78)
end


function loadModel(model)
    Citizen.CreateThread(function()
        while not HasModelLoaded(model) do
            RequestModel(model)
          Citizen.Wait(1)
        end
    end)
end


-----------------------------------------------------------------------------------------------------------------------------------------
-- MARCAÇÃO
-----------------------------------------------------------------------------------------------------------------------------------------
local blip = nil
RegisterNetEvent('blip:criar:caixaeletronico')
AddEventHandler('blip:criar:caixaeletronico',function(x,y,z)
	if not DoesBlipExist(blip) then
		blip = AddBlipForCoord(x,y,z)
		SetBlipScale(blip,0.5)
		SetBlipSprite(blip,1)
		SetBlipColour(blip,59)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Roubo: Caixa Eletrônico")
		EndTextCommandSetBlipName(blip)
		SetBlipAsShortRange(blip,false)
		SetBlipRoute(blip,true)
	end
end)

RegisterNetEvent('blip:remover:caixaeletronico')
AddEventHandler('blip:remover:caixaeletronico',function()
	if DoesBlipExist(blip) then
		RemoveBlip(blip)
		blip = nil
	end
end)

