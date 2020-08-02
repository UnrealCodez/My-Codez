local UIS = require(game.ServerScriptService.API:FindFirstChild("UIService"))
local SSS = game:GetService("ServerScriptService")
local SH = SSS:WaitForChild("SaveHandler")
local Game = game.Workspace.Game
local CollFolder = Game.Collectibles

local InitialAnimations =
{
	ByteAnimation = (function(Object)
		local Direction = 0 -- 0 = up; 1 = down
		local CurrentStep = 0 -- Max = 50
		while wait(0.01) do
			if CurrentStep == 0 then
				Direction = 0
			elseif CurrentStep == 50 then
				Direction = 1
			end
			if Direction == 0 then
				CurrentStep = CurrentStep + 1
				Object:SetPrimaryPartCFrame(Object:GetPrimaryPartCFrame() * CFrame.new(0, 0.01, 0) * CFrame.Angles(0, math.rad(2), 0))
			elseif Direction == 1 then
				CurrentStep = CurrentStep - 1
				Object:SetPrimaryPartCFrame(Object:GetPrimaryPartCFrame() * CFrame.new(0, -0.01, 0) * CFrame.Angles(0, math.rad(2), 0))
			end
			if Object:FindFirstChild("Properties") and Object.Properties.Collected.Value == true then
				break
			end
		end
	end)
}

local CollectAnimations =
{
	ByteAnimation = (function(Object)
		local Speed = 0.01
		while wait(0.01) do
			Object:SetPrimaryPartCFrame(Object:GetPrimaryPartCFrame() * CFrame.new(0, Speed*2, 0) * CFrame.Angles(0, math.rad(Speed*200), 0))
			Speed = Speed + 0.01
			for _, Part in ipairs(Object:GetChildren()) do
				if (Part:IsA("Part") or Part:IsA("UnionOperation")) and Part.Transparency < 1 then
					Part.Transparency = Part.Transparency + 0.04
				end
			end
			if Object:FindFirstChild("Properties") and Object.Properties.Collected.Value == true and Object.PrimaryPart.Transparency == 1 then
				break
			end
		end
	end);
	
	ScriptAnimation = (function(Object)
		local Speed = 0.01
		while wait(0.01) do
			Object:SetPrimaryPartCFrame(Object:GetPrimaryPartCFrame() * CFrame.new(0, Speed*2, 0) * CFrame.Angles(0, math.rad(Speed*100), 0))
			Speed = Speed + 0.001
			for _, Part in ipairs(Object:GetChildren()) do
				if (Part:IsA("Part") or Part:IsA("UnionOperation")) and Part.Transparency < 1 then
					Part.Transparency = Part.Transparency + 0.01
				end
			end
			if Object:FindFirstChild("Properties") and Object.Properties.Collected.Value == true and Object.PrimaryPart.Transparency == 1 then
				break
			end
		end
	end);
}

local CollectFunctions =
{
	Byte = (function(Player)
		SH.Collectibles.Byte.Value = SH.Collectibles.Byte.Value + 1
		Player.PlayerGui.Main.Main.Collectibles.BytesDisplay.Value:TweenSize(UDim2.new(2.2, 0, 0.7, 0), "Out", "Bounce", 0.2, true, nil)
		Player.PlayerGui.Main.Main.Collectibles.BytesDisplay.Value.Text = SH.Collectibles.Byte.Value
		wait(0.1)
		Player.PlayerGui.Main.Main.Collectibles.BytesDisplay.Value:TweenSize(UDim2.new(2, 0, 0.5, 0), "Out", "Bounce", 0.2, true, nil)
	end)
}

for _, Spawn in ipairs(CollFolder:GetChildren()) do
	if Spawn:IsA("Part") then
		local SpawnProperties = Spawn:FindFirstChild("Properties")
		local SpawnPropVars = require(SpawnProperties)
		local SPos = CFrame.new(Spawn.CFrame.p)
		local NewColl = script[Spawn.Name]:Clone()
		NewColl.Parent = CollFolder
		NewColl:SetPrimaryPartCFrame(SPos)
		spawn(function() InitialAnimations[SpawnPropVars.Animation.Init .. "Animation"](NewColl) end)
		
		if SpawnProperties ~= nil then
			SpawnProperties.Parent = NewColl
		end
		Spawn:Destroy()
		
		NewColl.Touch.Touched:connect(function(Hit)
			if Hit.Parent:FindFirstChild("Humanoid") then
				local Character = Hit.Parent
				local Player = game.Players:GetPlayerFromCharacter(Character)
				
				if SpawnProperties ~= nil and SpawnProperties.Collected.Value == false then
					SpawnProperties.Collected.Value = true
					wait()
					spawn(function() CollectAnimations[SpawnPropVars.Animation.Collect .. "Animation"](NewColl) end)
					if SpawnPropVars["Name"] then
						UIS.TopScreenUI(Player, "Collectible", NewColl)
					else
						CollectFunctions[NewColl.Name](Player)
					end
				end
			end
		end)
	end
end
