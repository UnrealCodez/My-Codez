		Lightning = (function(This)
			local Points = Instance.new("Model")
			local NewLightning = Instance.new("Model", This.Attacks)
			local StartPosition = This.TeslaRod.Start.Position
			local Origin
			local EndPosition
			
--[[
			local FakeRay = Instance.new("Part", script.Parent)
			FakeRay.Anchored = true
			FakeRay.Material = "Neon"
			FakeRay.BrickColor = BrickColor.Red()
			FakeRay.Size = Vector3.new(0.5, 110, 0.5)
--]]
			
			while wait() do
				if This.CheckEndPosition(This, EndPosition) == false then
					Origin, EndPosition = This.HandleRaycasting(StartPosition + Vector3.new(math.random(-80, 80), 0, math.random(-80, 80)), Vector3.new(0, -110, 0))
--					FakeRay.Position = Origin - Vector3.new(0, 55, 0)
				else
					break
				end
			end
			
			for I = 0, 1, 0.1 do
				local Point
				if I == 0 then
					Point = CFrame.new(StartPosition)
				elseif I == 1 then
					Point = CFrame.new(EndPosition)
				elseif I < 1 then
					Point = CFrame.new(StartPosition):Lerp(CFrame.new(EndPosition), I) * CFrame.new(Vector3.new(math.random(-50, 50)/10, 0, math.random(-50, 50)/10))
				end
				local NewPart = Instance.new("Part", Points)
				NewPart.Name = (I*10)+1
				NewPart.Anchored = true
				NewPart.Size = Vector3.new(1, 1, 1)
				NewPart.CFrame = Point
			end
			
			for I, Point in pairs(Points:GetChildren()) do
				print(I)
				if tonumber(string.match(Point.Name, "(%d+)")) < 11 then
					local NextPoint = Points[I + 1]
					local MiddlePoint = CFrame.new(Point.Position, NextPoint.Position):Lerp(NextPoint.CFrame, 0.5)
					local NewSection = Instance.new("Part", NewLightning)
					NewSection.Anchored = true
					NewSection.Size = Vector3.new(0.5, 0.5, (Point.Position - NextPoint.Position).magnitude)
					NewSection.CFrame =  CFrame.new(MiddlePoint.p)
					NewSection.CFrame = CFrame.new(NewSection.Position, NextPoint.Position)
					NewSection.Material = "Neon"
					NewSection.BrickColor = BrickColor.new("Royal purple")
				else
					break
				end
			end
			local LE = Instance.new("Explosion", game.Workspace)
			LE.Position = EndPosition
			LE.BlastPressure = 10
			LE.BlastRadius = 5
			for I = 1, 10 do
				for _, Segment in pairs(NewLightning:GetChildren()) do
					if Segment.BrickColor == BrickColor.new("Royal purple") then
						Segment.BrickColor = BrickColor.new("Pink")
					else
						Segment.BrickColor = BrickColor.new("Royal purple")
					end
				end
				wait(0.05)
			end
			NewLightning:Destroy()
		end);
	};
