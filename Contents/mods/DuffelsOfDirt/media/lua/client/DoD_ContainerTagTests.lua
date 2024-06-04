if not getActivatedMods():contains("TEST_FRAMEWORK") or not isDebugEnabled() then return end
local TestFramework = require("TestFramework/TestFramework")
local TestUtils = require("TestFramework/TestUtils")
local DOD_TestHelpers = require("DoD_TestHelpers")


TestFramework.registerTestModule("Duffels of Dirt", "Containers have appropriate tags", function ()
    local Tests = {}

    local player = getPlayer()
    local inventory = player:getInventory()
    inventory:removeAllItems()  --in case there's accidentally something left over from a previous test
    local containers_list = DOD_TestHelpers.getAllContainers()
    
    Tests.smallContainersAreExcluded = function ()
        if excluded_containers ~= 0 then
            for k,item in pairs(excluded_containers) do
                local item_name = tostring(item:getType())
                print(item_name .. " should be excluded for having a capacity below 4")
                local capacity = item:getCapacity()
                if capacity < 4 then
                    TestUtils.assert(true)
                else
                    TestUtils.assert(false)
                end
            end
        else
            print("No excluded containers found")
            TestUtils.assert(false)
        end
    end

    Tests.singleUnitBagsAreTagged = function ()
        if excluded_containers ~= 0 then
            for k,item in pairs(containers_by_solid_units[1]) do
                local item_name = tostring(item:getType())
                local capacity = item:getCapacity()
                local item_tags = item:getTags()
                local is_solid_container = item_tags:contains("_EmptySolidContainer")
                if capacity >= 4 and capacity < 8 then
                    --print(item_name .. "is >= 4 and < 8")
                    if is_solid_container then
                        --print(item_name .. " has _EmptySolidContainer tag")
                        TestUtils.assert(true)
                    else
                        print(item_name .. " does not have _EmptySolidContainer tag")
                        TestUtils.assert(false)
                    end
                else
                    print(item_name .. " was filtered into the wrong size category")
                    TestUtils.assert(false)
                end
            end
        else
            print("No excluded containers found")
            TestUtils.assert(false)
        end
    end

    Tests.doubleUnitBagsAreTagged = function ()
        TestUtils.assert(false)
    end

    Tests.tripleUnitBagsAreTagged = function ()
        TestUtils.assert(false)
    end

    Tests.quadrupleUnitBagsAreTagged = function ()
        TestUtils.assert(false)
    end

    Tests.quintupleUnitBagsAreTagged = function ()
        TestUtils.assert(false)
    end

    Tests.sextupleUnitBagsAreTagged = function ()
        TestUtils.assert(false)
    end

    Tests.septupleUnitBagsAreTagged = function ()
        TestUtils.assert(false)
    end
    
    --[[
    local small_containers_list = DOD_TestHelpers.getContainersUnder4(inventory)

    Tests.smallContainersNotSolidContainers = function ()
        DOD_TestHelpers.addAllContainers(player, containers_list)
        inventory = player:getInventory()
        for k,v in pairs(containers_list) do
            local item = containers_list[k]
            local item_tags = item:getTags()
            local is_solid_container = item_tags:contains("_EmptySolidContainer")
            TestUtils.assert(is_solid_container)
        end
        inventory:removeAllItems()
    end
    --]] 

    return Tests
end)


