local tabletProp = 0
local isOpen = false

RegisterNetEvent("tablet:open")
AddEventHandler("tablet:open", function()
    if isOpen then
        closeTablet()
    else
        openTablet()
    end
end)

function openTablet()
    isOpen = true

    RequestAnimDict("amb@code_human_in_bus_passenger_idles@female@tablet@idle_a")
    while not HasAnimDictLoaded("amb@code_human_in_bus_passenger_idles@female@tablet@idle_a") do
        Wait(10)
    end

    TaskPlayAnim(PlayerPedId(), "amb@code_human_in_bus_passenger_idles@female@tablet@idle_a", "idle_a", 8.0, 8.0, -1, 49, 0.0, false, false, false)

    local model = GetHashKey("prop_cs_tablet")
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(10)
    end

    tabletProp = CreateObject(model, 0, 0, 0, true, true, true)
    AttachEntityToEntity(tabletProp, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 60309), 0.03, 0.0, -0.02, 0.0, 0.0, 0.0, true, true, false, true, 1, true)

    SetNuiFocus(true, true)
    SendNUIMessage({ action = "open" })
end

function closeTablet()
    isOpen = false

    ClearPedTasks(PlayerPedId())
    DeleteEntity(tabletProp)

    SetNuiFocus(false, false)
    SendNUIMessage({ action = "close" })
end

RegisterNUICallback("exit", function()
    closeTablet()
end)
