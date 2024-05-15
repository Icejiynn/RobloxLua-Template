local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Bezier = require(ReplicatedStorage.Packages.Bezier)
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Promise = require(ReplicatedStorage.Packages.Promise)
local MapConstants = require(ReplicatedStorage.Shared.constants.MapConstants)

local STEP_DISTANCE = 0.3
local VISUALIZE = true
local VISUALIZE_PART: BasePart | nil

if VISUALIZE and (RunService:IsRunMode() and RunService:IsServer()) then
	VISUALIZE_PART = Fusion.New("Part") {
		Anchored = true,
		Transparency = 0.5,
		Material = Enum.Material.Neon,
		Size = Vector3.one * STEP_DISTANCE/2,
		Color = Color3.new(0.945098, 0.874510, 0.388235),
		CanCollide = false,
		CanTouch = false,
		Name = "visual_node"
	} :: BasePart
end

local function lerp(a: number, b: number, t: number)
	return a * (1-t) + b * t 
end

local function getNextNode(nodes: {BasePart}): BasePart
    local candidateNodes = {} :: {BasePart}
    local folder = (nodes[1]).Parent :: typeof(({} :: MapConstants.MapModel).Paths.a)

	local latestNode = nodes[#nodes]
    for i,v in folder:GetChildren() do
        if v ~= latestNode and not table.find(nodes, (v :: BasePart)) then
            table.insert(candidateNodes, (v :: BasePart))
        end
    end

    local nodeCount = #nodes
    
    local totalLookVector = Vector3.zero -- Initialize the totalLookVector
    local totalCheckingForAverage = math.max(nodeCount - 3, 1)
    
    for i = nodeCount, totalCheckingForAverage, -1 do
        totalLookVector += nodes[i].CFrame.LookVector
    end
    
    local averageLookVector = totalLookVector / (nodeCount - totalCheckingForAverage)
    local probabilities = {}
    
    for i,v in ipairs(candidateNodes) do
        local dot = math.deg(math.acos(averageLookVector:Dot(v.CFrame.LookVector))) -- Angle diff 0-180
        table.insert(probabilities, {node = v, probability = dot / ((latestNode.Position - v.Position).Magnitude ^ 1.3)}) -- Insert node along with its probability
    end
    
    table.sort(probabilities, function(a, b): boolean  -- Sort based on probability
        return a.probability > b.probability
    end)

    -- Return the node with the highest probability
    return probabilities[1].node 
end

local MapUtil = {}

function MapUtil.loadAllPaths(model: MapConstants.MapModel): Promise.TypedPromise<{MapConstants.PathData}>
	local pathChildren = model.Paths:GetChildren()
	table.sort(pathChildren, function(a0: Instance, a1: Instance): boolean  
		local a0Name = tonumber(a0.Name)
		local a1Name = tonumber(a1.Name)

		if a0Name and a1Name then
			return a0Name < a1Name
		else
			return a0.Name < a1.Name
		end
	end)

	local loadPromises: {Promise.TypedPromise<{BasePart}>} = {}
	for i = 1, #pathChildren do
		local path = pathChildren[i] :: typeof(model.Paths.a)
		if not tonumber(path.Name) then
			warn("The path", path, "has a non-number name, its order will be determined alphabetiacally")
		end

		table.insert(loadPromises, Promise.try(function(...)  
			local orderedNodes = {
				path.Start,
			}

			-- Sub 2 since we already know the start/end
			for i = 1, #path:GetChildren()-2 do
				table.insert(orderedNodes, getNextNode(orderedNodes))
			end

			table.insert(orderedNodes, path.End)

			return orderedNodes
		end))
	end


	return Promise.all(loadPromises):andThen(function(allPaths: {{BasePart}})
		local allVectors: {{Vector3}} = {}
		local raycastParams = RaycastParams.new()
		raycastParams.FilterType = Enum.RaycastFilterType.Include
		raycastParams:AddToFilter(model)

		for i = 1, #allPaths do
			local vectors = {}
			local nodes = allPaths[i]
			
			local progress = 0
			
			-- Calculate vectors between each node
			for i = 1, #nodes - 1 do
				local position, nextPosition = nodes[i].Position, nodes[i+1].Position
				if nodes[i]:FindFirstChild("BezierEnd") then
					position = (nodes[i]:FindFirstChild("BezierEnd") :: Attachment).WorldPosition
				end
				
				local distanceToNext = (position - nextPosition).Magnitude
				local addAlpha=  1 / math.ceil(distanceToNext/STEP_DISTANCE)

				local startBezier = (nodes[i+1]:FindFirstChild("BezierStart") :: Attachment)
				local endBezier = (nodes[i+1]:FindFirstChild("BezierEnd") :: Attachment)

				local bezier = if endBezier and startBezier then Bezier.new({
					startBezier.WorldPosition, 
					nodes[i+1].Position, 
					endBezier.WorldPosition
				}) else nil
				local bezierStartAlpha = if bezier then 
					1 - startBezier.Position.Magnitude/distanceToNext 
					else nil

				if bezier then
					bezier:UpdateLUT(100)
				end

				while progress < 1 do
					if bezier and progress >= (bezierStartAlpha :: number) then
						progress = math.min(1, progress + (STEP_DISTANCE/bezier.Length) * (1 - bezierStartAlpha))
					else
						progress = math.min(1, progress + addAlpha)
					end

					if progress < 1 then
						local finalPosition = if bezier and (progress >= bezierStartAlpha)
							then bezier:GetPoint(lerp(0, 1, math.max(0, (progress - bezierStartAlpha) / (1 - bezierStartAlpha)))) 
							else position:Lerp(nextPosition, progress)
						local raycast = workspace:Raycast(
							finalPosition + (Vector3.yAxis * 15), 
							Vector3.yAxis * -20,
							raycastParams
						)

						if raycast then
							finalPosition = raycast.Position
						end

						table.insert(vectors, finalPosition)
					end
				end

				progress = progress % 1
			end

			allVectors[i] = vectors
		end

		return allVectors
	end):andThen(function(paths: {{Vector3}}): ...any 
		local mappedPaths = {} :: {MapConstants.PathData}
		
		for i = 1, #paths do
			local vectors = paths[i]
			local nodeCount = #vectors
			local pathCFrames = {}

			for i = 1, #vectors-1 do
				pathCFrames[i] = CFrame.lookAt(vectors[i], vectors[i+1])
				if VISUALIZE_PART then
					Fusion.Hydrate(VISUALIZE_PART:Clone()) {
						Name = `visual_node {i}`,
						Parent = workspace,
						CFrame = pathCFrames[i],
					}
				end
			end

			-- Add final node with the same orientation as the one before it
			pathCFrames[nodeCount] = CFrame.new(vectors[nodeCount]) * CFrame.lookAt(vectors[nodeCount-1], vectors[nodeCount]).Rotation

			local length =0
			for i = 2, nodeCount do
				length += (vectors[i] - vectors[i-1]).Magnitude
			end

			mappedPaths[i] = {
				cframes = pathCFrames,
				length = length,
				nodeCount = nodeCount
			}
		end

		return mappedPaths
	end) :: Promise.TypedPromise<{MapConstants.PathData}>
end

return MapUtil