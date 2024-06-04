--[[
local clearInv = function(player)
    if player == nil then player = getPlayer() end
    local inventory = player:getInventory()
    local items = inventory:getItems()
    for i = 0, items:size() - 1 do
        --get(0) gets the top most item in inventory. If we did get(i) we can only remove half of the inventory 
        --before is greater than remaining items
        local item = items:get(0)
        print("removing " .. item:getType())
        inventory:Remove(item)
    end
    player:getWornItems():clear()
end

local addAllContainers = function(player, containers)
    for k, item in pairs(containers) do
    local item_full_name = item:getFullName()
        print("adding " .. item_full_name .. " to inventory")
    local created_item = InventoryItemFactory.CreateItem(item_full_name);
    player:getInventory():AddItem(created_item);
    end
end

local getAllContainers = function()
    local all_items = getScriptManager():getAllItems()
    local containers = {}
    print("getting all items:")
    print(all_items:size())
    for i = all_items:size() - 1, 0, -1 do
        local item = all_items:get(i)
        local item_type = tostring(item:getType())
        if item_type == "Container" then
            table.insert(containers, item)
        end
    end
    return containers
end

local containersMissingTags = function(list)
    if list == nil then print("forgot to send list to containersMissingTags") end
    local tagged_containers = {}
    local tagless_containers = {}
    for k,v in pairs(list) do
        local item = list[k]
        local item_tags = item:getTags()
        local is_solid_container = item_tags:contains("_EmptySolidContainer")
        if is_solid_container then
            print(item:getFullName())
            print("successfully configured with _EmptySolidContainer tag")
            table.insert(tagged_containers, item)
        else 
            print(item:getFullName())
            print("is missing tags. Making a note")
            table.insert(tagless_containers, item)
        end
    end
    return tagged_containers, tagless_containers
end

local capacityUnderFour = function (list)
    if list == nil then print("forgot to send list to capacityUnderFour") end
    local capacity_under_four = {}
    for k,v in pairs(list) do
        local item = list[k]
        --need to figure out capacity logic
        --[[
        local item_capacity = item:getCapacity()
        print("found item capacity:")
        print(item_capacity)
        if item_capacity < 4 then
            table.insert(capacity_under_four, item)
        end
        --]]
        
        
        
        --[[
    end
    return capacity_under_four
end

local printList = function(list)
    for k,v in pairs(list) do
        local item = list[k]
        print(item:getFullName())
    end
end

local function runTests(index, player)
    print("Running debug tests")
    clearInv(player)
    local all_containers = getAllContainers()
    addAllContainers(player, all_containers)

    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
    print("The following containers are tagged to hold solids")
    local tagged_containers, tagless_containers = containersMissingTags(all_containers)
    printList(tagged_containers)
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
    print("The following containers are missing the _EmptySolidContainer tag")
    printList(tagless_containers)
    
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
    print("The following containers have a capacity less than three")
    --local capacity_under_four = capacityUnderFour(all_containers)
    --printList(capacity_under_four)
    print("capacity under four is commented out")
end

if isDebugEnabled() then
    --this seems to only trigger when the player is first created, and not when loaded
    Events.OnCreatePlayer.Add(runTests)
    Events.OnWeaponSwing.Add(runTests)
else
    --skip it, we don't want to clutter a regular player with tons of errors
end
--]]