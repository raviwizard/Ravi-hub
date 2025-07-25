-- GUI Ravi Hub com função Grab Player
local player = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local runService = game:GetService("RunService")

local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "RaviHub"

local main = Instance.new("Frame", screenGui)
main.Size = UDim2.new(0, 200, 0, 300)
main.Position = UDim2.new(0, 20, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.BorderSizePixel = 0

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "Ravi Hub"
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.Code
title.TextSize = 18

-- Botão fechar
local closeBtn = Instance.new("TextButton", main)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.Code
closeBtn.TextSize = 14
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Botão teleport para tools
local teleportToolBtn = Instance.new("TextButton", main)
teleportToolBtn.Size = UDim2.new(0, 180, 0, 30)
teleportToolBtn.Position = UDim2.new(0, 10, 0, 50)
teleportToolBtn.Text = "Teleportar para Tools"
teleportToolBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
teleportToolBtn.TextColor3 = Color3.new(1, 1, 1)
teleportToolBtn.Font = Enum.Font.Code
teleportToolBtn.TextSize = 14
teleportToolBtn.MouseButton1Click:Connect(function()
    for _, tool in pairs(workspace:GetDescendants()) do
        if tool:IsA("Tool") then
            player.Character:MoveTo(tool.Position)
        end
    end
end)

-- Botão teleport para players
local teleportPlayerBtn = Instance.new("TextButton", main)
teleportPlayerBtn.Size = UDim2.new(0, 180, 0, 30)
teleportPlayerBtn.Position = UDim2.new(0, 10, 0, 90)
teleportPlayerBtn.Text = "Teleportar para Players"
teleportPlayerBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
teleportPlayerBtn.TextColor3 = Color3.new(1, 1, 1)
teleportPlayerBtn.Font = Enum.Font.Code
teleportPlayerBtn.TextSize = 14
teleportPlayerBtn.MouseButton1Click:Connect(function()
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            player.Character:MoveTo(plr.Character.HumanoidRootPart.Position)
        end
    end
end)

-- Função mover com teclas (WASD ou setas)
runService.RenderStepped:Connect(function()
    if uis:IsKeyDown(Enum.KeyCode.Left) then
        player.Character:TranslateBy(Vector3.new(-1, 0, 0))
    elseif uis:IsKeyDown(Enum.KeyCode.Right) then
        player.Character:TranslateBy(Vector3.new(1, 0, 0))
    elseif uis:IsKeyDown(Enum.KeyCode.Up) then
        player.Character:TranslateBy(Vector3.new(0, 0, -1))
    elseif uis:IsKeyDown(Enum.KeyCode.Down) then
        player.Character:TranslateBy(Vector3.new(0, 0, 1))
    end
end)

-- Grab Player
local grabToggle = Instance.new("TextButton", main)
grabToggle.Size = UDim2.new(0, 90, 0, 20)
grabToggle.Position = UDim2.new(0, 10, 0, 240)
grabToggle.Text = "Grab: Off"
grabToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
grabToggle.TextColor3 = Color3.new(1, 1, 1)
grabToggle.Font = Enum.Font.Code
grabToggle.TextSize = 12

local playerList = Instance.new("TextButton", main)
playerList.Size = UDim2.new(0, 90, 0, 20)
playerList.Position = UDim2.new(0, 100, 0, 240)
playerList.Text = "Selecionar Player"
playerList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
playerList.TextColor3 = Color3.new(1, 1, 1)
playerList.Font = Enum.Font.Code
playerList.TextSize = 12

local selectedTarget = nil
local grabbing = false
local dropdownMenu = nil

playerList.MouseButton1Click:Connect(function()
	if dropdownMenu then dropdownMenu:Destroy() dropdownMenu = nil return end

	dropdownMenu = Instance.new("Frame", screenGui)
	dropdownMenu.Position = UDim2.new(0, 220, 0.4, 0)
	dropdownMenu.Size = UDim2.new(0, 150, 0, 20 * #game.Players:GetPlayers())
	dropdownMenu.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	dropdownMenu.Name = "PlayerDropdown"

	for i, p in ipairs(game.Players:GetPlayers()) do
		if p ~= player then
			local btn = Instance.new("TextButton", dropdownMenu)
			btn.Size = UDim2.new(1, 0, 0, 20)
			btn.Position = UDim2.new(0, 0, 0, (i - 1) * 20)
			btn.Text = p.Name
			btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			btn.TextColor3 = Color3.new(1, 1, 1)
			btn.Font = Enum.Font.Code
			btn.TextSize = 12
			btn.MouseButton1Click:Connect(function()
				selectedTarget = p
				playerList.Text = p.Name
				dropdownMenu:Destroy()
				dropdownMenu = nil
			end)
		end
	end
end)

uis.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.Escape and dropdownMenu then
		dropdownMenu:Destroy()
		dropdownMenu = nil
	end
end)

grabToggle.MouseButton1Click:Connect(function()
	grabbing = not grabbing
	grabToggle.Text = "Grab: " .. (grabbing and "On" or "Off")
	if not grabbing and player.Character then
		local root = player.Character:FindFirstChild("HumanoidRootPart")
		if root then root.Anchored = false end
	end
end)

-- Loop para manter nas costas do player selecionado
runService.RenderStepped:Connect(function()
	if grabbing and selectedTarget and selectedTarget.Character and player.Character then
		local myRoot = player.Character:FindFirstChild("HumanoidRootPart")
		local targetRoot = selectedTarget.Character:FindFirstChild("HumanoidRootPart")
		if myRoot and targetRoot then
			myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 1)
		end
	end
end)
