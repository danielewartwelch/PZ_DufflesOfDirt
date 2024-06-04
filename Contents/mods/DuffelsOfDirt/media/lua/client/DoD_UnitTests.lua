if not getActivatedMods():contains("TEST_FRAMEWORK") or not isDebugEnabled() then return end
local TestFramework = require("TestFramework/TestFramework")
local TestUtils = require("TestFramework/TestUtils")
local DOD_TestHelpers = require("DoD_TestHelpers")


TestFramework.registerTestModule("Duffels of Dirt", "Unit Tests", function ()
    local Tests = {}

    local player = getPlayer()
    local inventory = player:getInventory()
    local items = inventory:getItems()
    local containers_list = DOD_TestHelpers.getAllContainers()
    
--[[
    Tests.Lunchbox2Tests = function ()
        local created_item = InventoryItemFactory.CreateItem("Lunchbox2")
        local item = player:getInventory():AddItem(created_item)
        --lunchbox has capacity of 4
        if item:getCapacity() == 4 then TestUtils.assert(true) else TestUtils.assert(false) end
        --lunchbox has tag _EmptySolidContainer
        if item:getTags():contains("_EmptySolidContainer") then TestUtils.assert(true) else TestUtils.assert(false) end
        --lunchbox has 4 replace types: dirt, gravel, sand, and fertilizer
        if item:getReplaceType("DirtSource") ~= "Lunchbox2_Dirt" then TestUtils.assert(false) end
        if item:getReplaceType("GravelSource") ~= "Lunchbox2_Gravel" then TestUtils.assert(false) end
        if item:getReplaceType("SandSource") ~= "Lunchbox2_Sand" then TestUtils.assert(false) end
        if item:getReplaceType("CompostSource") ~= "Lunchbox2_Fertilizer" then TestUtils.assert(false) end
        inventory:removeAllItems()
    end

    Tests.Lunchbox2_DirtTests = function ()
        local created_item = InventoryItemFactory.CreateItem("Lunchbox2_Dirt")
        local item = player:getInventory():AddItem(created_item)
        --filled lunchbox has weight of 1.5
        if item:getWeight() == 1.5 then TestUtils.assert(true) end
        --dirt container has Tags = _DirtContainer,
        --type Drainable, 
        --UseDelta = 1.0, 
        --DisplayName = Lunchbox of Dirt, 
        --ReplaceOnDeplete	= Lunchbox2,
        --UseWhileEquipped = FALSE,
        inventory:removeAllItems()
    end
--]]
    return Tests
end)


