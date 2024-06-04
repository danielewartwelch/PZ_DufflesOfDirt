if not getActivatedMods():contains("TEST_FRAMEWORK") or not isDebugEnabled() then return end
local TestFramework = require("TestFramework/TestFramework")
local TestUtils = require("TestFramework/TestUtils")
local DOD_TestHelpers = require("DoD_TestHelpers")

TestFramework.registerTestModule("Duffels of Dirt", "Regression Helpers", function ()
    local Tests = {}

    local player = getPlayer()
    local inventory = player:getInventory()
    local items = inventory:getItems()
    local containers_list = DOD_TestHelpers.getAllContainers()
    
    Tests.emptyInventory = function ()
        inventory:removeAllItems()
        TestUtils.assert(inventory:isEmpty())
    end

    Tests.addAllContainers = function ()
        DOD_TestHelpers.addAllContainers(player, containers_list)
        TestUtils.assert(inventory:isEmpty())
    end

    return Tests
end)

