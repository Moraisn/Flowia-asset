while GetResourceState("lb-tablet") ~= "started" do
	Wait(0)
end

local resourceName = GetCurrentResourceName()
local appOpen = false

local function SendDirection()
	Wait(500) -- allow the app to initialize

	local directions = { "N", "NE", "E", "SE", "S", "SW", "W", "NW" }
	local oldYaw, direction

	while appOpen do
		Wait(0)

		local yaw = math.floor(360.0 - ((GetFinalRenderedCamRot(0).z + 360.0) % 360.0) + 0.5)

		if yaw == 360 then
			yaw = 0
		end

		-- get closest direction
		if oldYaw ~= yaw then
			oldYaw = yaw
			direction = yaw .. "° " .. directions[math.floor((yaw + 22.5) / 45.0) % 8 + 1]

			exports["lb-tablet"]:SendCustomAppMessage(resourceName, "updateDirection", direction)
		end
	end
end

local function AddApp()
	local success, reason = exports["lb-tablet"]:AddCustomApp({
		identifier = resourceName,
		name = "Flowia",
		defaultApp = true,
		icon = "./assets/icon.webp", -- Chemin relatif vers le fichier local
		ui = "ui/index.html",
		removable = false,

		images = {
			"./assets/screenshot-dark.webp", -- Chemin relatif vers le fichier local
			"./assets/screenshot-light.webp" -- Chemin relatif vers le fichier local
		},

		onInstall = function()
			print("Flowia app installed")
		end,
		onUninstall = function()
			print("Flowia app uninstalled")
		end,
		onOpen = function()
			print("Flowia app opened")
			appOpen = true
			SendDirection()
		end,
		onClose = function()
			print("Flowia app closed")
			appOpen = false
		end,
	})

	if not success then
		print("Failed to add Flowia app: ", reason)
	else
		print("Successfully added Flowia app")
	end
end

AddApp()

AddEventHandler("onResourceStart", function(resource)
	Wait(500)

	if resource == "lb-tablet" then
		AddApp()
	end
end)