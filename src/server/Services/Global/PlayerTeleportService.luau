local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local Promise = require(ReplicatedStorage.Packages.Promise)

local ATTEMPT_LIMIT = 5
local RETRY_DELAY = 3
local FLOOD_DELAY = 15

local function SafeTeleport(
	placeId: number,
	teleportingPlayers: {Player},
	options: TeleportOptions?
)
	local attemptIndex = 0
	local success: boolean
	local result: TeleportAsyncResult

	while attemptIndex ~= ATTEMPT_LIMIT do
		success, result = pcall(function()
			return TeleportService:TeleportAsync(placeId, teleportingPlayers, options)
		end)
		attemptIndex += 1

		if (not success) then
			task.wait(RETRY_DELAY)
		else
			break
		end
	end

	if not success then
		warn(result) 
	end

	return success, result
end

local PlayerTeleportService = {}

function PlayerTeleportService:OnInit()
	-- If SafeTeleport fails without erroring this function is called
	local function handleFailedTeleport(
		player: Player,
		teleportResult: Enum.TeleportResult,
		errorMessage: string,
		placeId: number,
		teleportOptions: TeleportOptions
	)
		if teleportResult.Name == "Flooded" then
			task.wait(FLOOD_DELAY)
		elseif teleportResult.Name == "Failure" then
			task.wait(RETRY_DELAY)
		else
			-- if the teleport is invalid, report the error instead of retrying
			error((`Invalid teleport [%s]: %s`):format(teleportResult.Name, errorMessage))
		end

		SafeTeleport(placeId, {player}, teleportOptions)
	end

	TeleportService.TeleportInitFailed:Connect(handleFailedTeleport)
end

function PlayerTeleportService.teleport(
	placeId: number,
	teleportingPlayers: {Player},
	options: TeleportOptions?
)
	return Promise.new(function(resolve, reject)
		task.wait()

		local success, result = SafeTeleport(placeId, teleportingPlayers, options)
		if success then
			resolve(result);
		else
			reject();
		end
	end):catch(function()
		warn("Teleport failed!");
	end) :: Promise.TypedPromise<TeleportAsyncResult>
end

return PlayerTeleportService