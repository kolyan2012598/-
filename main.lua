-- 1. Авто-Фарм в воздухе
local autoGoldAir = false
local autoGoldBtn = createToggle("1. Авто-Фарм (В воздухе над водой)", 1, tabsContent[2])
autoGoldBtn.Activated:Connect(function()
	autoGoldAir = not autoGoldAir
	updateToggleVisual(autoGoldBtn, "1. Авто-Фарм (В воздухе над водой)", autoGoldAir)
	
	task.spawn(function()
		while autoGoldAir do
			local char = player.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				local hrp = char.HumanoidRootPart
				local stages = workspace:FindFirstChild("BoatStages") and workspace.BoatStages:FindFirstChild("NormalStages")
				
				local bv = Instance.new("BodyVelocity")
				bv.MaxForce = Vector3.new(0, math.huge, 0)
				bv.Velocity = Vector3.new(0, 0, 0)
				bv.Parent = hrp
				
				if stages then
					for i = 1, 10 do
						if not autoGoldAir then break end
						local stage = stages:FindFirstChild("CaveStage" .. tostring(i))
						if stage and stage:FindFirstChild("DarknessPart") then
							hrp.CFrame = stage.DarknessPart.CFrame * CFrame.new(0, 60, 0)
							task.wait(0.4)
						end
					end
					
					local endChest = stages:FindFirstChild("TheEnd") and stages.TheEnd:FindFirstChild("GoldenChest")
					if endChest and endChest:FindFirstChild("Trigger") then
						hrp.CFrame = endChest.Trigger.CFrame
					end
				end
				
				bv:Destroy()
			end
			task.wait(2)
		end
