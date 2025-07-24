-- Serviços
local player = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")
local mouse = player:GetMouse()

-- Estados
local espEnabled, jumpEnabled, speedEnabled, flyEnabled = false, false, false, false
local noclipEnabled, brightEnabled = false, false
local BodyGyro, BodyVelocity
local espObjects = {}

-- Ferramenta de teleporte
local function giveTeleportTool()
	local tool = Instance.new("Tool")
	tool.RequiresHandle = false
	tool.Name = "Teleport Tool"
	tool.Parent = player.Backpack

	tool.Activated:Connect(function()
		if mouse then
			local pos = mouse.Hit.Position
			if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				player.Character.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 5, 0))
			end
		end
	end)
end

-- GUI
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "MiniHub"
screenGui.ResetOnSpawn = false

local main = Instance.new("Frame", screenGui)
main.Position = UDim2.new(0, 10, 0.4, 0)
main.Size = UDim2.new(0, 200, 0, 260)
main.BackgroundColor3 = Color3.new(0, 0, 0)
main.BackgroundTransparency = 0.65
main.BorderSizePixel = 0
main.Name = "MainFrame"
main.Active = true
main.Draggable = true

-- Borda RGB animada
local stroke = Instance.new("UIStroke")
stroke.Thickness = 2
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.LineJoinMode = Enum.LineJoinMode.Round
stroke.Parent = main

local hue = 0
runService.RenderStepped:Connect(function()
	hue = (hue + 0.002) % 1
	stroke.Color = Color3.fromHSV(hue, 1, 1)
end)

-- Botão com nome "Ravi Hub" e animação de minimizar
local toggleBtn = Instance.new("TextButton", main)
toggleBtn.Size = UDim2.new(1, 0, 0, 20)
toggleBtn.Position = UDim2.new(0, 0, 0, 0)
toggleBtn.Text = "Ravi Hub"
toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.Code
toggleBtn.TextSize = 13

local contentVisible = true
local fullSize = UDim2.new(0, 200, 0, 260)
local minimizedSize = UDim2.new(0, 200, 0, 20)

local function toggleContent()
	contentVisible = not contentVisible
	for _, obj in ipairs(main:GetChildren()) do
		if obj ~= toggleBtn and not obj:IsA("UIStroke") then
			obj.Visible = contentVisible
		end
	end
	local goal = { Size = contentVisible and fullSize or minimizedSize }
	tweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), goal):Play()
end

toggleBtn.MouseButton1Click:Connect(toggleContent)

-- Criação de opções
local function createOption(name, y)
	local label = Instance.new("TextLabel", main)
	label.Text = name
	label.Size = UDim2.new(0, 90, 0, 20)
	label.Position = UDim2.new(0, 10, 0, y)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.new(1, 1, 1)
	label.Font = Enum.Font.Code
	label.TextSize = 12

	local toggle = Instance.new("TextButton", main)
	toggle.Size = UDim2.new(0, 30, 0, 20)
	toggle.Position = UDim2.new(0, 100, 0, y)
	toggle.Text = "Off"
	toggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	toggle.TextColor3 = Color3.new(1, 1, 1)
	toggle.Font = Enum.Font.Code
	toggle.TextSize = 12

	local input = Instance.new("TextBox", main)
	input.Size = UDim2.new(0, 50, 0, 20)
	input.Position = UDim2.new(0, 140, 0, y)
	input.Text = "50"
	input.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	input.TextColor3 = Color3.new(1, 1, 1)
	input.Font = Enum.Font.Code
	input.TextSize = 12
	input.ClearTextOnFocus = false

	return toggle, input
end

-- Botões principais
local jumpToggle, jumpBox = createOption("Pulo Alto", 30)
local speedToggle, speedBox = createOption("Velocidade", 60)
local flyToggle, flyBox = createOption("Voar", 90)

local espToggle = Instance.new("TextButton", main)
espToggle.Size = UDim2.new(0, 180, 0, 20)
espToggle.Position = UDim2.new(0, 10, 0, 120)
espToggle.Text = "ESP: Off"
espToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
espToggle.TextColor3 = Color3.new(1, 1, 1)
espToggle.Font = Enum.Font.Code
espToggle.TextSize = 12

local noclipToggle = Instance.new("TextButton", main)
noclipToggle.Size = UDim2.new(0, 180, 0, 20)
noclipToggle.Position = UDim2.new(0, 10, 0, 150)
noclipToggle.Text = "Noclip: Off"
noclipToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
noclipToggle.TextColor3 = Color3.new(1, 1, 1)
noclipToggle.Font = Enum.Font.Code
noclipToggle.TextSize = 12

local brightToggle = Instance.new("TextButton", main)
brightToggle.Size = UDim2.new(0, 180, 0, 20)
brightToggle.Position = UDim2.new(0, 10, 0, 180)
brightToggle.Text = "Bright: Off"
brightToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
brightToggle.TextColor3 = Color3.new(1, 1, 1)
brightToggle.Font = Enum.Font.Code
brightToggle.TextSize = 12

local teleportToolBtn = Instance.new("TextButton", main)
teleportToolBtn.Size = UDim2.new(0, 180, 0, 20)
teleportToolBtn.Position = UDim2.new(0, 10, 0, 210)
teleportToolBtn.Text = "Pegar Teleport Tool"
teleportToolBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
teleportToolBtn.TextColor3 = Color3.new(1, 1, 1)
teleportToolBtn.Font = Enum.Font.Code
teleportToolBtn.TextSize = 12

-- Conexões
jumpToggle.MouseButton1Click:Connect(function()
	jumpEnabled = not jumpEnabled
	jumpToggle.Text = jumpEnabled and "On" or "Off"
end)

speedToggle.MouseButton1Click:Connect(function()
	speedEnabled = not speedEnabled
	speedToggle.Text = speedEnabled and "On" or "Off"
end)

flyToggle.MouseButton1Click:Connect(function()
	flyEnabled = not flyEnabled
	flyToggle.Text = flyEnabled and "On" or "Off"
	local char = player.Character
	if not flyEnabled and char then
		if BodyGyro then BodyGyro:Destroy() BodyGyro = nil end
		if BodyVelocity then BodyVelocity:Destroy() BodyVelocity = nil end
		local hum = char:FindFirstChild("Humanoid")
		if hum then hum.PlatformStand = false end
	end
end)

espToggle.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	espToggle.Text = "ESP: " .. (espEnabled and "On" or "Off")
	if not espEnabled then
		for _, esp in ipairs(espObjects) do
			if esp and esp.Parent then esp:Destroy() end
		end
		espObjects = {}
	end
end)

noclipToggle.MouseButton1Click:Connect(function()
	noclipEnabled = not noclipEnabled
	noclipToggle.Text = "Noclip: " .. (noclipEnabled and "On" or "Off")
end)

brightToggle.MouseButton1Click:Connect(function()
	brightEnabled = not brightEnabled
	brightToggle.Text = "Bright: " .. (brightEnabled and "On" or "Off")
	local lighting = game:GetService("Lighting")
	if brightEnabled then
		lighting.Brightness = 5
		lighting.ClockTime = 12
		lighting.FogEnd = 1000000
		lighting.GlobalShadows = false
	else
		lighting.Brightness = 1
		lighting.ClockTime = 14
		lighting.FogEnd = 1000
		lighting.GlobalShadows = true
	end
end)

teleportToolBtn.MouseButton1Click:Connect(function()
	giveTeleportTool()
end)

-- Loops
runService.RenderStepped:Connect(function()
	local char = player.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") then return end
	local humanoid = char.Humanoid
	local hrp = char.HumanoidRootPart

	humanoid.UseJumpPower = true
	humanoid.JumpPower = jumpEnabled and tonumber(jumpBox.Text) or 50
	humanoid.WalkSpeed = speedEnabled and tonumber(speedBox.Text) or 16

	if flyEnabled then
		if not BodyGyro or not BodyVelocity then
			BodyGyro = Instance.new("BodyGyro", hrp)
			BodyGyro.P = 9e4
			BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
			BodyVelocity = Instance.new("BodyVelocity", hrp)
			BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
			humanoid.PlatformStand = true
		end
		local cam = workspace.CurrentCamera
		local speed = tonumber(flyBox.Text) or 50
		BodyGyro.CFrame = cam.CFrame
		BodyVelocity.Velocity = cam.CFrame.LookVector * speed
	end

	if espEnabled then
		for _, p in pairs(game.Players:GetPlayers()) do
			if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
				if not p.Character.Head:FindFirstChild("ESP") then
					local tag = Instance.new("BillboardGui", p.Character.Head)
					tag.Name = "ESP"
					tag.Size = UDim2.new(0, 100, 0, 40)
					tag.StudsOffset = Vector3.new(0, 2, 0)
					tag.AlwaysOnTop = true

					local nameLabel = Instance.new("TextLabel", tag)
					nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
					nameLabel.BackgroundTransparency = 1
					nameLabel.Text = p.Name
					nameLabel.TextColor3 = Color3.new(1, 1, 1)
					nameLabel.Font = Enum.Font.Code
					nameLabel.TextSize = 14

					local distLabel = Instance.new("TextLabel", tag)
					distLabel.Size = UDim2.new(1, 0, 0.5, 0)
					distLabel.Position = UDim2.new(0, 0, 0.5, 0)
					distLabel.BackgroundTransparency = 1
					distLabel.TextColor3 = Color3.new(1, 1, 1)
					distLabel.Font = Enum.Font.Code
					distLabel.TextSize = 12

					runService.RenderStepped:Connect(function()
						if player.Character and p.Character and player.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("HumanoidRootPart") then
							local dist = (player.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
							distLabel.Text = string.format("Distância: %.1f", dist)
						end
					end)

					table.insert(espObjects, tag)
				end
			end
		end
	end
end)

runService.Stepped:Connect(function()
	if noclipEnabled then
		local char = player.Character
		if char then
			for _, part in ipairs(char:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end
		end
	end
end)
