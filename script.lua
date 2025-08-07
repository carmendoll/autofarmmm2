-- Anti-AFK
local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
 vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
 wait(1)
 vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- GUI Setup
local gui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "MM2FarmGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 120)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Size = UDim2.new(1, -10, 0, 50)
toggleBtn.Position = UDim2.new(0, 5, 0, 5)
toggleBtn.Text = "Start AutoFarm"
toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 20

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(1, -10, 0, 40)
closeBtn.Position = UDim2.new(0, 5, 0, 65)
closeBtn.Text = "❌ Close"
closeBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 18

-- Logic
local farming = false

local function getCoins()
 local coins = {}
 for _, v in pairs(workspace:GetDescendants()) do
  if v:IsA("Part") and v.Name == "Coin" then
   table.insert(coins, v)
  end
 end
 return coins
end

local function getCoinCount()
 local guiRoot = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
 if not guiRoot then return 0 end

 local mainGui = guiRoot:FindFirstChild("MainGUI")
 if not mainGui then return 0 end

 local bar = mainGui:FindFirstChild("Topbar")
 if not bar then return 0 end

 local coinLabel = bar:FindFirstChild("CoinBar")
 if not coinLabel then return 0 end

 local coins = coinLabel:FindFirstChild("Coins")
 if not coins then return 0 end

 local str = coins.Text:match("(%d+)")
 return tonumber(str) or 0
end

local function teleportTo(vec)
 local char = game.Players.LocalPlayer.Character
 if char and char:FindFirstChild("HumanoidRootPart") then
  char.HumanoidRootPart.CFrame = CFrame.new(vec + Vector3.new(0, 3, 0))
 end
end

local function startFarm()
 while farming do
  if getCoinCount() >= 40 then
   local char = game.Players.LocalPlayer.Character
   if char and char:FindFirstChild("Humanoid") then
    char.Humanoid.Health = 0
   end
   wait(6)
  else
   teleportTo(Vector3.new(0, -100, 0))
   wait(0.5)
   for _, coin in pairs(getCoins()) do
    if not farming then break end
    teleportTo(coin.Position)
    wait(0.5)
   end
  end
  wait(1)
 end
end

-- Button Actions
toggleBtn.MouseButton1Click:Connect(function()
 farming = not farming
 toggleBtn.Text = farming and "Stop AutoFarm" or "Start AutoFarm"
 if farming then
  coroutine.wrap(startFarm)()
 end
end)

closeBtn.MouseButton1Click:Connect(function()
 gui:Destroy()
end)

-- Toggle GUI visibility with RightShift
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, gameProcessed)
 if input.KeyCode == Enum.KeyCode.RightShift and not gameProcessed then
  gui.Enabled = not gui.Enabled
 end
end)
