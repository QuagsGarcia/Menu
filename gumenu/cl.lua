RegisterKeyMapping('leomenu', 'LEO Menu', 'keyboard', "m")
RegisterCommand("leomenu", function(src, args)
    if lib.callback.await('gumenu:isAllowed', src) then
	   toggleMenu()
    end
end)
lib.registerMenu({
    id = 'leomenu',
    title = 'LEO Menu',
    position = 'top-right',
    onSideScroll = function(selected, scrollIndex, args)

    end,
    onSelected = function(selected, secondary, args)
        if not secondary then
            
        else
            if args.isCheck then
                
            end
 
            if args.isScroll then
                
            end
        end
        
    end,
    onCheck = function(selected, checked, args)
        
    end,
    onClose = function(keyPressed)
        
        if keyPressed then
            
        end
    end,
    options = {
        {label = 'Cuff Player', description = 'Used to Cuff/Uncuff players.', args={menuoption="cuff"}, close=false},
        {label = 'Drag Player', description = 'Used to Drag/Release players.', args={menuoption="drag"}, close=false},
        {label = 'Seat Player', description = 'Used to Seat players.', args={menuoption="seat"}, close=false},
        {label = 'Unseat Player', description = 'Used to Unseat players.', args={menuoption="unseat"}, close=false},
        {label = 'Set Spikes', description = 'Used to set spikes.', values = {'1', '2', '3', '4'}, args={menuoption="setSpikes"}, close=false},
        {label = 'Remove Spikes', description = 'Used to remove spikes.', args={menuoption="removeSpikes"}, close=false},
        {label = 'Spawn Props', description = 'Used to spawn props.', values = {'Police Barrier', 'Barrier', 'Traffic Cone', 'Cone', 'Work Barrier', "Work Barrier 2"}, args={menuoption="spawnProps"}, close=false},
        {label = 'Remove Props', description = 'Used to remove props.', args={menuoption="removeProps"}, close=false},
        {label = 'Jail Player', description = 'Used to Jail players.', args={menuoption="jailPlayer"}, close=true},
        {label = 'Release Player', description = 'Used to release players.', args={menuoption="releasePlayer"}, close=true},
        {label = 'Hospitalize Player', description = 'Used to hospitalize players.', args={menuoption="hospitalizePlayer"}, close=true},
        {label = 'Station Teleport', description = 'Used to teleport to stations.', values = {'Corryton Station', 'Skaggston Station', 'Mission Row Station', 'La Mesa Station', 'Davis Station'}, args={menuoption="stationSelect"}, close=false},
    }
}, function(selected, scrollIndex, args)
	doaction(args["menuoption"], scrollIndex)
end)
local stations = {
    [1] = vector4(-437.6174, 6009.2007, 36.9957, 128.7893),
    [2] = vector4(1840.2295, 3680.0649, 34.1892, 84.8551),
    [3] = vector4(461.6606, -999.1446, 30.6896, 269.7630),
    [4] = vector4(854.3686, -1312.7855, 28.2449, 24.5789),
    [5] = vector4(360.7090, -1593.5232, 25.4517, 194.1599),
}
function toggleMenu()
	if not lib.getOpenMenu() then
		lib.showMenu("leomenu")
	else
		lib.hideMenu(true)
	end
end

function doaction(optn, scroll)
	if optn == "setSpikes" then
		setSpikes(scroll)
	elseif optn == "removeSpikes" then
		removeSpikes()
    elseif optn == "cuff" then
        TriggerEvent("QuagsCuffing:CuffHandling")
    elseif optn == "drag" then
        TriggerEvent("QuagsCuffing:DragHandling")
    elseif optn == "seat" then
        seatPlayer()
    elseif optn == "unseat" then
        unSeatPlayer()
    elseif optn == "stationSelect" then
        stationSelect(scroll)
    elseif optn == "spawnProps" then
        spawnMenuProp(scroll)
    elseif optn == "removeProps" then
        removeProps()
    elseif optn == "jailPlayer" then
        JailPlayer()
    elseif optn == "releasePlayer" then
        ReleasePlayer()
    elseif optn == "hospitalizePlayer" then
        HospitalizePlayer()
	end
end

local propTable = {
    [1] = "prop_barrier_work05",
    [2] = "prop_barrier_work06a",
    [3] = "prop_roadcone01a",
    [4] = "prop_roadcone02b",
    [5] = "prop_mp_barrier_02b",
    [6] = "prop_barrier_work01a",
}
local propTableNames = {
    [1] = "Police Barrier",
    [2] = "Barrier",
    [3] = "Traffic Cone",
    [4] = "Cone",
    [5] = "Work Barrier",
    [6] = "Work Barrier 2",
}
function HospitalizePlayer()
    local PlayerID = tonumber(KeyboardInput('Player ID:', "", 4))
    if PlayerID == nil then
        Notify('Please enter a player ID.')
        return
    end
    TriggerServerEvent("gumenu:hospitalize-S", PlayerID)
end
function KeyboardInput(textEntry, exampleText, maxStringLength)
    AddTextEntry('FMMC_KEY_TIP1', textEntry) -- Sets the Text above the typing field in the black square
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", exampleText, "", "", "", maxStringLength) -- Opens the Keyboard

    while true do
        local status = UpdateOnscreenKeyboard()
        
        if status == 1 then
            local result = GetOnscreenKeyboardResult()
            return result -- Gets the result of the typing
        elseif status == 2 then
            return nil -- User canceled the input
        end
        Citizen.Wait(200)
    end
end
function JailPlayer()
    local PlayerID = tonumber(KeyboardInput('Player ID:', "", 4))
    if PlayerID == nil then
        Notify('Please enter a player ID.')
        return
    end

    local JailTime = tonumber(KeyboardInput('Time: (Months) - Max Time: 1000', "", 4))
    if JailTime > 1000 then
        Notify('Please enter a time fewer than 1000 months.')
        return
    end
    TriggerServerEvent('QuagsJailing:JailCorrectClient', PlayerID, JailTime, GetPlayerServerId(PlayerId()))
end
function ReleasePlayer()
    local PlayerID = tonumber(KeyboardInput('Player ID:', "", 4))
    if PlayerID == nil then
        Notify('Please enter a player ID.')
        return
    end
    TriggerServerEvent('QuagsJailing:JailCorrectClient', PlayerID, "unjail", GetPlayerServerId(PlayerId()))
end

function removeProps()
    TriggerServerEvent("gumenu:removeprops-S", {coords=GetEntityCoords(GetPlayerPed(-1))})
end

function spawnMenuProp(optn)
    SpawnProp(propTable[optn], propTableNames[optn])
end

function SpawnProp(Object, Name)
    local Player = PlayerPedId()
    local Coords = GetEntityCoords(Player)
    local Heading = GetEntityHeading(Player)

    RequestModel(Object)
    while not HasModelLoaded(Object) do
        Citizen.Wait(0)
    end

    local OffsetCoords = GetOffsetFromEntityInWorldCoords(Player, 0.0, 0.75, 0.0)
    local Prop = CreateObjectNoOffset(Object, OffsetCoords, false, true, false)
    SetEntityHeading(Prop, Heading)
    PlaceObjectOnGroundProperly(Prop)
    SetEntityCollision(Prop, false, true)
    SetEntityAlpha(Prop, 100)
    FreezeEntityPosition(Prop, true)
    SetModelAsNoLongerNeeded(Object)

    Popup('Press ~g~E ~w~to place\nPress ~r~R ~w~to cancel')

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)

            local OffsetCoords = GetOffsetFromEntityInWorldCoords(Player, 0.0, 0.75, 0.0)
            local Heading = GetEntityHeading(Player)

            SetEntityCoordsNoOffset(Prop, OffsetCoords)
            SetEntityHeading(Prop, Heading)
            PlaceObjectOnGroundProperly(Prop)
            DisableControlAction(1, 38, true) --E
            DisableControlAction(1, 140, true) --R
            
            
            if IsDisabledControlJustPressed(1, 38) then --E
                local PropCoords = GetEntityCoords(Prop)
                local PropHeading = GetEntityHeading(Prop)
                DeleteObject(Prop)

                RequestModel(Object)
                while not HasModelLoaded(Object) do
                    Citizen.Wait(0)
                end

                local Prop = CreateObjectNoOffset(Object, PropCoords, true, true, true)
                SetEntityHeading(Prop, PropHeading)
                PlaceObjectOnGroundProperly(Prop)
                FreezeEntityPosition(Prop, true)
                SetEntityInvincible(Prop, true)
                SetModelAsNoLongerNeeded(Object)
                return
            end

            if IsDisabledControlJustPressed(1, 140) then --R
                DeleteObject(Prop)
                return
            end
        end
    end)
end
function IsMpPed(ped)
    local Male = GetHashKey("mp_m_freemode_01") local Female = GetHashKey("mp_f_freemode_01")
    local CurrentModel = GetEntityModel(ped)
    if CurrentModel == Male then return "Male" elseif CurrentModel == Female then return "Female" else return false end
end
function Popup(Text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(Text)
    DrawNotification(true, true)
end
function stationSelect(opt)
    local ped = GetPlayerPed(-1)
    local info = stations[opt]
    SetEntityCoords(ped, info.x, info.y, info.z)
    SetEntityHeading(ped, info.w)
end

function getClosestDoor(vehicle)
    local doors = {
        ["door_pside_f"] = 0,
        ["door_pside_r"] = 2,
        ["door_dside_r"] = 1,
    }
    local closestDoor = "door_pside_f"
    for _, i in pairs(doors) do
        local doorPos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, _))
        local dist1 = #(GetEntityCoords(GetPlayerPed(-1)) - doorPos)
        local dist2 = #(GetEntityCoords(GetPlayerPed(-1)) - GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, closestDoor)))
        if dist1 < dist2 then
           closestDoor = _
        end
    end
    closestDoor = doors[closestDoor]
    return closestDoor
end

function seatPlayer()
    if DecorGetBool(GetPlayerPed(-1), "isDragging") then
        local vehs = surveyVehicles(5.0, GetEntityCoords(GetPlayerPed(-1)))
        local closest = 0
        if json.encode(vehs) ~= "[]" then
            for _, i in pairs(vehs) do
                local dist1 = #(GetEntityCoords(i.ent) - GetEntityCoords(GetPlayerPed(-1)))
                local dist2 = #(GetEntityCoords(closest) - GetEntityCoords(GetPlayerPed(-1)))
                if dist1 < dist2 then
                    closest = i.ent
                end
            end
            local _, ped, coords = lib.getClosestPlayer(GetEntityCoords(GetPlayerPed(-1)), 10.0, false)
            TriggerEvent("QuagsCuffing:SeatPlayer", ped, closest, getClosestDoor(closest))
        end
    else
        Notify("You are not dragging anyone.")
    end
end

function unSeatPlayer()
        local vehs = surveyVehicles(5.0, GetEntityCoords(GetPlayerPed(-1)))
        local closest = 0
        if json.encode(vehs) ~= "[]" then
            for _, i in pairs(vehs) do
                local dist1 = #(GetEntityCoords(i.ent) - GetEntityCoords(GetPlayerPed(-1)))
                local dist2 = #(GetEntityCoords(closest) - GetEntityCoords(GetPlayerPed(-1)))
                if dist1 < dist2 then
                    closest = i.ent
                end
            end
            if not IsVehicleSeatFree(closest, getClosestDoor(closest)) then
                if GetPedConfigFlag(GetPedInVehicleSeat(closest, getClosestDoor(closest)), 120) then
                    TriggerServerEvent("gumenu:leavevehicle-S", GetPlayerServerId(NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(closest, getClosestDoor(closest)))))
                end
            else
                Notify("Seat is empty.")
            end
            
        end
end
RegisterNetEvent('gumenu:leaveVehicle')
AddEventHandler('gumenu:leaveVehicle', function()
    TaskLeaveVehicle(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1)), 0)
end)

function setCivilianClothing()
    local ped = GetPlayerPed(-1)
    if IsMpPed(ped) then
        if IsMpPed(ped) == "Male" then
            setCivMale(ped)
        else
            setCivFemale(ped)
        end
    end
end

function setCivMale(ped)
    SetPedComponentVariation(ped, 1, 0, 0, 0)
    SetPedComponentVariation(ped, 3, 6, 0, 0)
    SetPedComponentVariation(ped, 4, 7, 0, 0)
    SetPedComponentVariation(ped, 5, 0, 0, 0)
    SetPedComponentVariation(ped, 6, 7, 0, 0)
    SetPedComponentVariation(ped, 7, 0, 0, 0)
    SetPedComponentVariation(ped, 8, 5, 0, 0)
    SetPedComponentVariation(ped, 9, 0, 0, 0)
    SetPedComponentVariation(ped, 10, 0, 0, 0)
    SetPedComponentVariation(ped, 11, 7, 2, 0)
    ClearPedProp(ped, 0)
    ClearPedProp(ped, 1)
    ClearPedProp(ped, 2)
    ClearPedProp(ped, 6)
    ClearPedProp(ped, 7)
end

function setCivFemale(ped)
    SetPedComponentVariation(ped, 1, 0, 0, 0)
    SetPedComponentVariation(ped, 3, 3, 0, 0)
    SetPedComponentVariation(ped, 4, 3, 0, 0)
    SetPedComponentVariation(ped, 5, 0, 0, 0)
    SetPedComponentVariation(ped, 6, 103, 0, 0)
    SetPedComponentVariation(ped, 7, 0, 0, 0)
    SetPedComponentVariation(ped, 8, 14, 0, 0)
    SetPedComponentVariation(ped, 9, 0, 0, 0)
    SetPedComponentVariation(ped, 10, 0, 0, 0)
    SetPedComponentVariation(ped, 11, 3, 2, 0)
    ClearPedProp(ped, 0)
    ClearPedProp(ped, 1)
    ClearPedProp(ped, 2)
    ClearPedProp(ped, 6)
    ClearPedProp(ped, 7)
end

RegisterNetEvent('gumenu:hospitalize')
AddEventHandler('gumenu:hospitalize', function()
    DoScreenFadeOut(500)
    Citizen.Wait(500)
    local timer = GetGameTimer() + 5000
    TriggerEvent("GURevivePlayer")
    while IsEntityDead(GetPlayerPed(-1)) and timer > GetGameTimer() do
        Citizen.Wait(100)
    end
    SetEntityCoords(GetPlayerPed(-1), vector3(313.3021, -581.5472, 43.2841))
    SetEntityHeading(GetPlayerPed(-1), 288.9440)
    setCivilianClothing()
    Citizen.Wait(1000)
    DoScreenFadeIn(500)
    Citizen.Wait(500)
    Notify("You were admitted to the hospital.")
end)
function setSpikes(amt)
	TriggerServerEvent("gumenu:setspikes-S", amt, {coords=GetEntityCoords(GetPlayerPed(-1)), heading=GetEntityHeading(GetPlayerPed(-1))})
end

function removeSpikes()
	TriggerServerEvent("gumenu:removespikes-S", {coords=GetEntityCoords(GetPlayerPed(-1))})
end

RegisterNetEvent('gumenu:setspikes')
AddEventHandler('gumenu:setspikes', function(amt, tbl)
	local SpawnCoords = GetOffsetFromCoordAndHeadingInWorldCoords(tbl.coords.x, tbl.coords.y, tbl.coords.z, tbl.heading, 0.0, 3.0, 0.0)
    for a = 1, amt do
        local Spike = CreateObject(GetHashKey('P_ld_stinger_s'), SpawnCoords.x, SpawnCoords.y, SpawnCoords.z, 1, 1, 1)
        SetEntityHeading(Spike, tbl.heading)
        PlaceObjectOnGroundProperly(Spike)
        FreezeEntityPosition(Spike, true)
        SpawnCoords = GetOffsetFromEntityInWorldCoords(Spike, 0.0, 4.0, 0.0)
    end
end)

propList = {
    [`prop_barrier_work05`] = true,
    [`prop_barrier_work06a`] = true,
    [`prop_roadcone01a`] = true,
    [`prop_roadcone02b`] = true,
    [`prop_mp_barrier_02b`] = true,
    [`prop_barrier_work01a`] = true,
}

RegisterNetEvent('gumenu:removeprops')
AddEventHandler('gumenu:removeprops', function(tbl)
	for i in EnumerateObjects() do
		if propList[GetEntityModel(i)] then
			local c1 = tbl.coords
	        local c2 = GetEntityCoords(i)
	        local dist = #(c1 - c2)
	        if dist <= 5 then
	        	DetachEntity(i, 0, false)
	            SetEntityCollision(i, false, false)
	            SetEntityAlpha(i, 0.0, true)
	            SetEntityAsMissionEntity(i, true, true)
	            SetEntityAsNoLongerNeeded(i)
	            SetEntityCoords(i, 0.0, 0.0, 0.0)
	            DeleteEntity(i)
	        end
		end
	end
end)

local entityEnumerator = {
  __gc = function(enum)
    if enum.destructor and enum.handle then
      enum.destructor(enum.handle)
    end
    enum.destructor = nil
    enum.handle = nil
  end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
  return coroutine.wrap(function()
    local iter, id = initFunc()
    if not id or id == 0 then
      disposeFunc(iter)
      return
    end
    
    local enum = {handle = iter, destructor = disposeFunc}
    setmetatable(enum, entityEnumerator)
    
    local next = true
    repeat
      coroutine.yield(id)
      next, id = moveFunc(iter)
    until not next
    
    enum.destructor, enum.handle = nil, nil
    disposeFunc(iter)
  end)
end

function surveyVehicles(radius, entcoords)
    local tbl = {}
    for i in EnumerateVehicles() do
        local c1 = GetEntityCoords(i)
        local c2 = entcoords
        local dist = #(c1 - c2)
        if dist <= radius then
            table.insert(tbl, {ent=i, dist=dist})
        end
    end
    return tbl
end

function EnumerateVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function EnumerateObjects()
  return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

--Spike Strip Tire Popping
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(25)

        if IsPedInAnyVehicle(PlayerPedId() , false) then
            local Vehicle = GetVehiclePedIsIn(PlayerPedId() , false)

            if GetPedInVehicleSeat(Vehicle, -1) == PlayerPedId()  then
                local VehiclePos = GetEntityCoords(Vehicle, false)
                local Spike = GetClosestObjectOfType(VehiclePos.x, VehiclePos.y, VehiclePos.z, 2.0, GetHashKey('P_ld_stinger_s'), 1, 1, 1)

                if Spike ~= 0 then
                    local Tires = {
                        {bone = 'wheel_lf', index = 0},
                        {bone = 'wheel_rf', index = 1},
                        {bone = 'wheel_lm', index = 2},
                        {bone = 'wheel_rm', index = 3},
                        {bone = 'wheel_lr', index = 4},
                        {bone = 'wheel_rr', index = 5}
                    }
        
                    for a = 1, #Tires do
                        local TirePos = GetWorldPositionOfEntityBone(Vehicle, GetEntityBoneIndexByName(Vehicle, Tires[a].bone))
                        local Spike = GetClosestObjectOfType(TirePos.x, TirePos.y, TirePos.z, 2.0, GetHashKey('P_ld_stinger_s'), 1, 1, 1)
                        local SpikePos = GetEntityCoords(Spike, false)
                        local Distance = Vdist(TirePos.x, TirePos.y, TirePos.z, SpikePos.x, SpikePos.y, SpikePos.z)
            
                        if Distance < 1.8 then
                            if not IsVehicleTyreBurst(Vehicle, Tires[a].index, true) or IsVehicleTyreBurst(Vehicle, Tires[a].index, false) then
                                SetVehicleTyreBurst(Vehicle, Tires[a].index, false, 1000.0)
                            end
                        end
                    end
                end
            end
        end
    end
end)

function Notify(text)
    TriggerEvent("QuagsNotify:Icon", "LEO Menu", text, 5000, 'info', "mdi-handcuffs")
end