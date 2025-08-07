--// Anti-AFK
local VirtualUser = game:service'VirtualUser'
game:service'Players'.LocalPlayer.Idled:connect(function()
   VirtualUser:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
   wait(1)
   VirtualUser:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

--// GUI
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Toggle = Instance.new("TextButton")
local Running = false

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Name = "MM2AutoFarmGui"

Frame.Size = UDim2.new(0, 200, 0, 100)
Frame.Position = UDim2.new(0, 10, 0, 10)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.Parent = ScreenGui

Toggle.Size = UDim2.new(1, 0, 0, 50)
Toggle.Position = UDim2.new(0, 0, 0, 0)
Toggle.Text = "Start AutoFarm"
Toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Toggle.TextColor3 = Color3.new(1, 1, 1)
Toggle.Font = Enum.Font.SourceSansBold
Toggle.TextSize = 20
Toggle.Parent = Frame

--// Underground Position (adjust as needed)
local UndergroundPosition = Vector3.new(0, -100, 0) -- Y=-100 to stay underground

--// Autofarm Logic
local function getCoins()
    local coins = {}
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "Coin" and v:IsA("Part") then
            table.insert(coins, v)
        end
    end
    return coins
end

local function getCoinCount()
    local player = game.Players.LocalPlayer
    local status = player:FindFirstChild("PlayerGui"):FindFirstChild("MainGUI"):FindFirstChild("Topbar"):FindFirstChild("CoinBar"):FindFirstChild("Coins")
    if status then
        local str = status.Text:match("(%d+)")
        return tonumber(str) or 0
    end
    return 0
end

local function teleportTo(pos)
    local character = game.Players.LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:MoveTo(pos)
    end
end

local function autoFarm()
    while Running do
        local bagFull = getCoinCount() >= 40
        if bagFull then
            -- Reset character
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.Health = 0
            end
            wait(6) -- wait for respawn
        else
            -- Stay underground to avoid detection
            teleportTo(UndergroundPosition)
            wait(0.5)

            -- Look for nearby coins and teleport to collect
            for _, coin in pairs(getCoins()) do
                if not Running then break end
                teleportTo(coin.Position)
                wait(0.5)
            end
        end
        wait(1)
    end
end

--// Toggle Button Logic
Toggle.MouseButton1Click:Connect(function()
    Running = not Running
    Toggle.Text = Running and "Stop AutoFarm" or "Start AutoFarm"
    if Running then
        coroutine.wrap(autoFarm)()
    end
end)
