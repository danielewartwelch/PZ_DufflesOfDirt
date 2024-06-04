local DoD_TestHelpers = {}

DoD_TestHelpers.foo = "barbarbarbarbar"

function DoD_TestHelpers.addAllContainers(player, list)
    print("Adding all containers to player inventory")
    for k, item in pairs(list) do
    local item_full_name = item:getFullName()
        print("adding " .. item_full_name .. " to inventory")
    local created_item = InventoryItemFactory.CreateItem(item_full_name)
    player:getInventory():AddItem(created_item);
    end
end

function DoD_TestHelpers.getAllContainers()
    local all_items = getScriptManager():getAllItems()
    local containers = {}
    for i = all_items:size() - 1, 0, -1 do
        local item = all_items:get(i)
        local item_type = tostring(item:getType())
        if item_type == "Container" then
            table.insert(containers, item)
        end
    end
    return containers
end

function DoD_TestHelpers.printList(list)
    for k,v in pairs(list) do
        print("key: " .. k)
        print("item: " .. v:getName())
    end
end

function DoD_TestHelpers.getAllDrainable()
    local all_items = getScriptManager():getAllItems()
    local drainable = {}
    for i = all_items:size() - 1, 0, -1 do
        local item = all_items:get(i)
        local item_type = tostring(item:getType())
        if item_type == "Drainable" then
            table.insert(drainable, item)
        end
    end
    return drainable
end

function DoD_TestHelpers.containersMissingTags(list)
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

function DoD_TestHelpers.getCapacity(item_name)
    local item = getScriptManager():getItem(item_name)
    local instance_item  = item:InstanceItem(item:getFullName())
    local instance_capacity = instance_item:getCapacity()
    return instance_capacity
end

function DoD_TestHelpers.getWeightReduction(item_name)
    local item = getScriptManager():getItem(item_name)
    local instance_item  = item:InstanceItem(item:getFullName())
    local instance_weight_reduction = instance_item:getWeightReduction()
    return instance_weight_reduction
end

function DoD_TestHelpers.getMetalValue(item_name)
    local item = getScriptManager():getItem(item_name)
    local instance_item  = item:InstanceItem(item:getFullName())
    local instance_metal_value = instance_item:getMetalValue()
    return instance_metal_value
end

function DoD_TestHelpers.getWorldStaticModel(item_name)
    local item = getScriptManager():getItem(item_name)
    local instance_item = item:InstanceItem(item:getFullName()) 
    local numClassFields = getNumClassFields(item)
    print("found " .. numClassFields .. " fields")
    for i = 0, numClassFields - 1 do
        ---@type Field
        local javaField = getClassField(item, i)
        if javaField then
            if tostring(javaField) == "public java.lang.String zombie.scripting.objects.Item.worldStaticModel" then
                local value = getClassFieldVal(item, javaField)
                --print("returning value:")
                --print(value)
                return value
            end
        end
    end
end

function DoD_TestHelpers.hasDirtType(item_name)

end

return DoD_TestHelpers