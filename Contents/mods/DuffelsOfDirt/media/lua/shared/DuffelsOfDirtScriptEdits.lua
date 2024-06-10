local DoD_TestHelpers = require("DoD_TestHelpers")

local DoDEdits = {}
DoDEdits.Items = {
    ["CompostBag"] = {
        Tags = { _FertilizerContainer = true },
    },
    ["Dirtbag"] = {
        Tags = { _DirtContainer = true },
    },
    ["EmptySandbag"] = {
        Tags = { _EmptySolidContainer = true },
        ReplaceTypes = "DirtSource Dirtbag;GravelSource Gravelbag;SandSource Sandbag;CompostSource CompostBag"
    },
    ["Fertilizer"] = {
        Tags = { _FertilizerContainer = true },
    },
    ["Gravelbag"] = {
        Tags = { _GravelContainer = true },
    },
    ["Sandbag"] = {
        Tags = { _SandContainer = true },
    },
    ["SackCabbages"] = {
        Tags = { _EmptySolidContainer = true },
        ReplaceTypes = "DirtSource Dirtbag;GravelSource Gravelbag;SandSource Sandbag;CompostSource CompostBag"
    },
    ["SackCarrots"] = {
        Tags = { _EmptySolidContainer = true },
        ReplaceTypes = "DirtSource Dirtbag;GravelSource Gravelbag;SandSource Sandbag;CompostSource CompostBag"
    },
    ["SackPotatoes"] = {
        Tags = { _EmptySolidContainer = true },
        ReplaceTypes = "DirtSource Dirtbag;GravelSource Gravelbag;SandSource Sandbag;CompostSource CompostBag"
    },
    ["SackOnions"] = {
        Tags = { _EmptySolidContainer = true },
        ReplaceTypes = "DirtSource Dirtbag;GravelSource Gravelbag;SandSource Sandbag;CompostSource CompostBag"
    },
}

function DoDEdits.lessTooSmallCapacity(containers_list)
    --holds a list of table keys to remove
    local remove_list = {}
    for k,v in pairs(containers_list) do
        local capacity = DoD_TestHelpers.getCapacity(v:getName())
        if capacity < 4 then
            table.insert(remove_list,k)
        end
    end
    --iterate backwards because otherwise the table key shifts items we don't want shifted
    for i = #remove_list, 1, -1 do
        local key = remove_list[i]
        print(containers_list[key]:getName() .. " is too small to hold solids")
        table.remove(containers_list,key)
    end
    return containers_list
end

function DoDEdits.lessAlreadyTaggedContainers(list)
    --search through manually typed DoDEdits to remove them from the dynamically built container list    
    for DoDEdits_key,edit_item_name in pairs(DoDEdits.Items) do
        for list_key,item in pairs(list) do
            if DoDEdits_key == item:getName() then
                print(item:getName() .. " is already tagged as an an _EmptySolidContainer")
                table.remove(list, list_key)
                break
            end
        end
    end
    return list
end

function DoDEdits.lessMissingDrainableTypes(containers_list)
    print("removing items that are missing drainable types")
    local drainable_list = DoD_TestHelpers.getAllDrainable()
    local remove_list = {}
    for container_key,container_item in pairs(containers_list) do
        local container_name = container_item:getName()
        local match_bitfield = 0
        for drainable_key, drainable_item in pairs(drainable_list) do
            local drainable_name = drainable_item:getName()
            local drainable_gsub = drainable_name
            drainable_gsub = string.gsub(drainable_gsub, "_Dirt", "")
            drainable_gsub = string.gsub(drainable_gsub, "_Gravel", "")
            drainable_gsub = string.gsub(drainable_gsub, "_Sand", "")
            drainable_gsub = string.gsub(drainable_gsub, "_Fertilizer", "")
            --string.match isn't good enough because lunchbox2_dirt would still match lunchbox. need EXACT match
            if drainable_gsub == container_name then
                local tags = drainable_item:getTags()
                for i = 0, tags:size() - 1 do
                    local tag = tags:get(i)
                    if tag == "_DirtContainer" then
                        match_bitfield = match_bitfield + 1
                        --print("found dirt container for " .. container_name .. " match bitfield is: " .. match_bitfield)
                    elseif tag == "_GravelContainer" then
                        match_bitfield = match_bitfield + 2
                        --print("found gravel container for " .. container_name .. " match bitfield is: " .. match_bitfield)
                    elseif tag == "_SandContainer" then
                        match_bitfield = match_bitfield + 4
                        --print("found sand container for " .. container_name .. " match bitfield is: " .. match_bitfield)
                    elseif tag == "_FertilizerContainer" then
                        match_bitfield = match_bitfield + 8
                        --print("found fertilizer container for " .. container_name .. " match bitfield is: " .. match_bitfield)
                    end
                end
            end
            --print("bitfield for " .. container_name .. " is: " ..match_bitfield)
        end
        --only keep the container in the list if it has all four drainable types
        if match_bitfield ~= 15 then
            --print("solids container type is missing for " .. container_name)
            --print("now removing " .. #remove_list .. " items from the container edit list" )
            table.insert(remove_list,container_key)
        end
    end
    for i = #remove_list, 1, -1 do
        local key = remove_list[i]
        print(containers_list[key]:getName() .. " is missing drainable types")
        table.remove(containers_list,key)
    end
    return containers_list
end

function DoDEdits.injectExtraContainers()
    --fetch all container types
    local containers_list = DoD_TestHelpers.getAllContainers()
    print("~~~found " .. #containers_list .. "container items")
    containers_list = DoDEdits.lessTooSmallCapacity(containers_list)
    print("~~~removed too small. left with " .. #containers_list .. " container items")
    containers_list = DoDEdits.lessAlreadyTaggedContainers(containers_list)
    print("~~~removed already tagged. left with " .. #containers_list .. " container items")
    --containers_list = DoDEdits.lessMissingDrainableTypes(containers_list)
    --print("~~~removed missing drainable types. left with " .. #containers_list .. " container items")
    for _,item in pairs(containers_list) do
        local itemName = item:getName()
        local itemCapacity = DoD_TestHelpers.getCapacity(itemName)
        --need to also skip sacks and sandbags
        if itemCapacity >= 4 then
            DoDEdits.Items[itemName] = {
                ["Tags"] = { _EmptySolidContainer = true },
                ["ReplaceTypes"] = "DirtSource " .. itemName .. "_Dirt" ..
                                  ";GravelSource " .. itemName .. "_Gravel" ..
                                  ";SandSource "  .. itemName  .. "_Sand" ..
                                  ";CompostSource " .. itemName .. "_Fertilizer"
                }
        end
    end
end

--local noise = getDebug() and print or function() end --lol
function DoDEdits.applyDoDEdits()
    if not DoDEdits.Items then return end
    local manager = getScriptManager()
    local item
    for k,v in pairs(DoDEdits.Items) do
        item = manager:getItem(k)
        for key,value in pairs(v) do
            if key == "Tags" then
                local tags = item:getTags()
                for tag,bool in pairs(v.Tags) do
                    if bool then
                        tags:add(tag)
                    else
                        tag:remove(tag)
                    end
                end
            else
                item:DoParam(key.." = "..value)
            end
            --noise("Script Edit: "..key..", "..value) --lol
        end
    end
    DoDEdits.Items = nil
end


--[[function DoDEdits.addItem(itemName, itemProperty, propertyValue)
    if not DoDEdits.Items[itemName] then DoDEdits.Items[itemName] = {} end
    DoDEdits.Items[itemName][itemProperty] = propertyValue
end
--]]

Events.OnGameBoot.Add(DoDEdits.injectExtraContainers)
Events.OnGameBoot.Add(DoDEdits.applyDoDEdits)


return DoDEdits