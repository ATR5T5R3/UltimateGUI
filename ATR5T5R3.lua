local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false

-- حقوق الشيخ + مربع المفتاح --
local rightsFrame = Instance.new("Frame", gui)
rightsFrame.Position = UDim2.new(0, 10, 0, 10)
rightsFrame.Size = UDim2.new(0, 220, 0, 120)
rightsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
rightsFrame.BackgroundTransparency = 0.3
rightsFrame.BorderSizePixel = 0
rightsFrame.Active = true
rightsFrame.Draggable = true

local rightsLabel = Instance.new("TextLabel", rightsFrame)
rightsLabel.Size = UDim2.new(1, 0, 0, 30)
rightsLabel.Position = UDim2.new(0, 0, 0, 0)
rightsLabel.Text = "حقوق الشيخ"
rightsLabel.TextColor3 = Color3.new(1,1,1)
rightsLabel.BackgroundTransparency = 1
rightsLabel.Font = Enum.Font.SourceSansBold
rightsLabel.TextSize = 20

local keyInput = Instance.new("TextBox", rightsFrame)
keyInput.Size = UDim2.new(1, -20, 0, 30)
keyInput.Position = UDim2.new(0, 10, 0, 40)
keyInput.PlaceholderText = "اكتب المفتاح هنا"
keyInput.Text = ""
keyInput.ClearTextOnFocus = true
keyInput.TextColor3 = Color3.new(1,1,1)
keyInput.BackgroundColor3 = Color3.fromRGB(40,40,40)
keyInput.Font = Enum.Font.SourceSans
keyInput.TextSize = 18

local discordBtn = Instance.new("TextButton", rightsFrame)
discordBtn.Size = UDim2.new(1, -20, 0, 30)
discordBtn.Position = UDim2.new(0, 10, 0, 80)
discordBtn.Text = "تعال ديسكورد للمفتاح"
discordBtn.Font = Enum.Font.SourceSansBold
discordBtn.TextSize = 18
discordBtn.TextColor3 = Color3.new(1,1,1)
discordBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)

discordBtn.MouseButton1Click:Connect(function()
	setclipboard("https://discord.gg/PBTrMHVq")
	discordBtn.Text = "تم النسخ ✅"
	wait(2)
	discordBtn.Text = "تعال ديسكورد للمفتاح"
end)

-- الإطار الرئيسي للواجهة
local mainFrame = Instance.new("Frame", gui)
mainFrame.Position = UDim2.new(0, 10, 0.5, -150)
mainFrame.Size = UDim2.new(0, 240, 0, 360)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BackgroundTransparency = 0.3
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = false

-- زر إظهار / إخفاء الواجهة
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 120, 0, 40)
toggleBtn.Position = UDim2.new(0, 10, 0, 140)
toggleBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
toggleBtn.BackgroundTransparency = 0.3
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Text = "إظهار / إخفاء الواجهة"
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 18

toggleBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)

-- تزيين الزوايا 🔲
for _, pos in ipairs({
	Vector2.new(0, 0),
	Vector2.new(230, 0),
	Vector2.new(0, 350),
	Vector2.new(230, 350)
}) do
	local redDot = Instance.new("TextLabel", mainFrame)
	redDot.Position = UDim2.new(0, pos.X, 0, pos.Y)
	redDot.Size = UDim2.new(0, 10, 0, 10)
	redDot.Text = "🔲"
	redDot.BackgroundTransparency = 1
	redDot.TextScaled = true
end

-- دالة إنشاء زر بحجم متوسط (3x3 ترتيب)
local function createBtn(text, row, col)
	local btnSize = UDim2.new(0, 70, 0, 70)
	local padding = 5
	local xPos = (col - 1) * (70 + padding)
	local yPos = (row - 1) * (70 + padding) + 25
	local btn = Instance.new("TextButton", mainFrame)
	btn.Size = btnSize
	btn.Position = UDim2.new(0, xPos, 0, yPos)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 20
	btn.Text = text
	return btn
end

-- المتغيرات المشتركة
local dead = false
local flying = false
local flyConn
local savedPos
local walkSquare = false
local walkSquareConn
local chasing = false
local chaseConn
local currentTarget = nil

local antiTouchEnabled = false -- مش مستخدم الآن لكن خليته جاهز

-- متغيرات الطيران fling
local flinging = false
local flingConn
local flingStartPos

-- سرعة الطيران fling
local flingSpeed = 80

-- متغيرات Fly عادي
local flySpeed = 40

local function updateFlyBtnText()
	flyBtn.Text = "Fly\n("..flySpeed..")"
end

-- إنشاء الأزرار 3x3

-- الصف 1: Fly + -
local flyBtn = createBtn("Fly\n("..flySpeed..")", 1, 1)
local plusBtn = createBtn("+", 1, 2)
local minusBtn = createBtn("-", 1, 3)

-- الصف 2: موت - قرب لاعب - مربع
local deadBtn = createBtn("موت", 2, 1)
local teleportCloseBtn = createBtn("قرب لاعب", 2, 2)
local squareBtn = createBtn("⬜", 2, 3)

-- الصف 3: مطارده - Teleport - tp
local chaseBtn = createBtn("مطارده", 3, 1)
local teleportSaveBtn = createBtn("Teleport", 3, 2)
local tpBtn = createBtn("tp", 3, 3)

-- الصف 4: ⬆️ - Speed - تطيير
local jumpBtn = createBtn("⬆️", 4, 1)
local speedBtn = createBtn("Speed", 4, 2)
local flingBtn = createBtn("تطيير", 4, 3)

-- وظائف الأزرار:

-- 1. موت
deadBtn.MouseButton1Click:Connect(function()
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then return end
	dead = not dead
	if dead then
		hum:ChangeState(Enum.HumanoidStateType.Physics)
		for _, v in pairs(char:GetChildren()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
				v.Anchored = false
			end
		end
		hrp.CFrame = hrp.CFrame * CFrame.Angles(math.rad(90), 0, 0)
		hrp.Velocity = Vector3.new(0, -50, 0)
	else
		hum:ChangeState(Enum.HumanoidStateType.GettingUp)
	end
end)

-- 2. قرب لاعب (Teleport خلف أقرب لاعب)
teleportCloseBtn.MouseButton1Click:Connect(function()
	local closestPlayer = nil
	local closestDistance = math.huge
	local myPos = hrp.Position

	for _, otherPlayer in pairs(Players:GetPlayers()) do
		if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local otherPos = otherPlayer.Character.HumanoidRootPart.Position
			local dist = (otherPos - myPos).Magnitude
			if dist < closestDistance then
				closestDistance = dist
				closestPlayer = otherPlayer
			end
		end
	end

	if closestPlayer then
		local targetHRP = closestPlayer.Character.HumanoidRootPart
		local backPosition = targetHRP.CFrame * CFrame.new(0, 0, 2)
		hrp.CFrame = backPosition
	end
end)

-- 3. مربع (يمشي في مربع 40 وحدة باتجاهات 4)
squareBtn.MouseButton1Click:Connect(function()
	walkSquare = not walkSquare
	if walkSquare then
		local directions = {
			Vector3.new(0, 0, -1),
			Vector3.new(1, 0, 0),
			Vector3.new(0, 0, 1),
			Vector3.new(-1, 0, 0),
		}
		local index = 1
		if walkSquareConn then walkSquareConn:Disconnect() end
		walkSquareConn = RunService.Heartbeat:Connect(function()
			if not walkSquare then return end
			local dir = directions[index]
			hrp.Velocity = dir * 40
		end)
		spawn(function()
			while walkSquare do
				wait(1)
				index = index + 1
				if index > #directions then index = 1 end
			end
		end)
	else
		if walkSquareConn then walkSquareConn:Disconnect() end
		hrp.Velocity = Vector3.zero
	end
end)

-- 4. مطارده (يتتبع أقرب لاعب)
local function findClosestPlayer(exclude)
	local closestPlayer = nil
	local closestDistance = math.huge
	local myPos = hrp.Position

	for _, otherPlayer in pairs(Players:GetPlayers()) do
		if otherPlayer ~= player and otherPlayer ~= exclude and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local otherPos = otherPlayer.Character.HumanoidRootPart.Position
			local dist = (otherPos - myPos).Magnitude
			if dist < closestDistance then
				closestDistance = dist
				closestPlayer = otherPlayer
			end
		end
	end

	return closestPlayer
end

chaseBtn.MouseButton1Click:Connect(function()
	chasing = not chasing
	if chasing then
		currentTarget = nil
		local lastReachTime = tick()
		if chaseConn then chaseConn:Disconnect() end
		chaseConn = RunService.Heartbeat:Connect(function()
			if not currentTarget or not currentTarget.Character or not currentTarget.Character:FindFirstChild("HumanoidRootPart") then
				currentTarget = findClosestPlayer(currentTarget)
				lastReachTime = tick()
			end
			if currentTarget and currentTarget.Character and currentTarget.Character:FindFirstChild("HumanoidRootPart") then
				local targetHRP = currentTarget.Character.HumanoidRootPart
				local targetPos = targetHRP.Position - Vector3.new(0, targetHRP.Size.Y / 2 or 2, 0)
				local direction = (targetPos - hrp.Position)
				local dist = direction.Magnitude
				if dist < 2 then
					currentTarget = findClosestPlayer(currentTarget)
					lastReachTime = tick()
				else
					local dirNorm = direction.Unit

					-- تفادي الجدران
					local rayOrigin = hrp.Position
					local rayDir = dirNorm * 3
					local raycastParams = RaycastParams.new()
					raycastParams.FilterDescendantsInstances = {char}
					raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
					local raycastResult = workspace:Raycast(rayOrigin, rayDir, raycastParams)

					if raycastResult and raycastResult.Instance and raycastResult.Instance.CanCollide then
						-- اتجاه بديل (يسار)
						local leftDir = CFrame.new().LookVector:Cross(Vector3.new(0,1,0))
						hrp.Velocity = leftDir * 40
					else
						hrp.Velocity = dirNorm * 40
					end

					if tick() - lastReachTime > 1.5 then
						currentTarget = findClosestPlayer(currentTarget)
						lastReachTime = tick()
					end
				end
			else
				hrp.Velocity = Vector3.zero
			end
		end)
	else
		if chaseConn then chaseConn:Disconnect() end
		hrp.Velocity = Vector3.zero
		currentTarget = nil
	end
end)

-- 5. حفظ الموقع (Teleport)
teleportSaveBtn.MouseButton1Click:Connect(function()
	savedPos = hrp.Position
end)

-- 6. الذهاب للموقع المحفوظ (tp)
tpBtn.MouseButton1Click:Connect(function()
	if savedPos then
		hrp.CFrame = CFrame.new(savedPos)
	end
end)

-- 7. القفز عالي (⬆️)
jumpBtn.MouseButton1Click:Connect(function()
	hrp.CFrame = hrp.CFrame + Vector3.new(0, 120, 0)
end)

-- 8. سرعة المشي (Speed)
speedBtn.MouseButton1Click:Connect(function()
	local hum = char:F
