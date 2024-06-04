item = "Duffel_Dirt"
groundType = "dirt"

prefixLoc = string.find(item, "_")
print(prefixLoc)
jobTypePrefix = string.sub(item, 1, prefixLoc)
print(jobTypePrefix)



--[[TEST PLAN
    - test with actual sacks
    - test with several types of added bags    
--]]



-- need to add `item:hasTag("HoldDirt")` to existing bags
-- https://discord.com/channels/136501320340209664/232196827577974784/934746076790001684


-- albion's suggestion for how to intercept existing functions
-- https://discord.com/channels/136501320340209664/232196827577974784/1119136110933708831

--[[

if getActivatedMods():contains("BucketsMultipurpose") == true then
	print("buckets activated")
    require("BucketsMultipurpose");
else
    print("buckets not activated")
end


local testRequire = function()
    items = getPlayer():getInventory():getItems()
    for i = 0, items:size() - 1 do
        item = items:get(i)
        print("checking if " .. item:getType() .. " is unbroken shovel")  
        result = predicateDirtToolNotBroken(item)
    end
end

Events.OnGameStart.Add(testRequire)


 Can be used to determine if an item is a valid bag
local function predicateEmpty(item)
	return item:hasTag("HoldDirt") and item:getInventory():isEmpty();
end

function HaveEmptyItem()
	local playerInv = getPlayer():getInventory()
	local item = playerInv:getFirstEvalRecurse(predicateEmpty)
	if item then 
		print("found an empty `dirt` bag in player inv")
	else 
		print("no empty bag")
	end
	print("haveemptyitem run")
end

Events.OnPlayerAttackFinished.Add(HaveEmptyItem)

local allItems = {}
local allFillableBagTypes = {}
local playerFillableBagTypes = {}
local dod_JobTypes = {}

local dod_GetAllFillableBags = function()
    local allItems = getScriptManager():getAllItems()
    print("getting all items:")
    print(allItems:size())
    --print(#allBagTypes)
    for i = allItems:size() - 1, 0, -1 do
        local item = allItems:get(i)
        local displayCategory = item:getDisplayCategory()
        local itemTags = item:getTags()
        local canHoldDirt = itemTags:contains("HoldDirt")
        local itemFullName = item:getFullName()
        if displayCategory == "Bag" and canHoldDirt then
            print("found an eligible item:")
            print(itemFullName)
            table.insert(allFillableBagTypes, item)
        end
    end
    print("found " .. #allFillableBagTypes .. " eligible bags")
end

local dod_CreateJobTypes = function()
    for _, v in ipairs(allFillableBagTypes) do
        item = v
        local itemTags = item:getTags()
        local itemFullName = item:getFullName()
        local dirtContext = itemFullName .. "_Dirt"
        local gravelContext = itemFullName .. "_Gravel"
        local sandContext = itemFullName .. "_Sand"
        print("dirtcontext: " .. dirtContext)
        allFillableBagTypes[dirtContext] = "ContextMenu_Take_some_dirt"
        print("added contextmenu link for " .. dirtContext)
        allFillableBagTypes[gravelContext] = "ContextMenu_Take_some_gravel"
        print("added contextmenu link for " .. gravelContext)
        allFillableBagTypes[sandContext] = "ContextMenu_Take_some_sands"
        print("added contextmenu link for " .. sandContext)
    end
end

--[[ this will need to determine all the bags that can be filled, that are
    --empty (no non dirt items)
    --have the tag "HoldDirt"   
        OR 
    --able to take more dirt 

    -------

local dod_IsDirtBag = function(item)
    name = item:getType()
    return string.find(name, "dirt") or string.find(name,"gravel") or string.find(name,"sand")
end

local dod_getPlayerFillableBags = function(playerObj)
    --getItemsFromCategory?
    local playerItems = playerObj:getInventory():getItems()
    for i = 0, playerItems:size() - 1 do
        local item = playerItems:get(i)
        if item:getCategory() == "Container" then
            print(item:getType() .. " is a container")
            if(item:ContainsTag("HoldDirt") or dod_IsDirtBag(item)) then
                print("and it's a dirt fillable bag")
            end
        end
    end
end



dod_GetAllFillableBags()
dod_CreateJobTypes()



---[[
local old_SGC_GetEmptyItem = ISShovelGroundCursor.GetEmptyItem
ISShovelGroundCursor.GetEmptyItem = function(playerObj, groundType)
    
    print("attempting to intercept SGC.GetEmptyItem")
    dod_getPlayerFillableBags(playerObj)
    
    local fullType,item = old_SGC_GetEmptyItem(playerObj, groundType)
    temp = dod_LocatePartiallyFilled()
    
    print ("itemnameis: " .. item:getName())
    item_name = item:getName()
    
    -------------------------------------------------------------------------------------------------------
    --changing fulltype like this isn't going to work, 
    --see if we can build the fulltype by concatenating strings (update: we can)
    --if item_name = "Duffle Bag" then fulltypeprefix = 'Duffel_'
    --if groundtype = 'dirt' then fulltypesuffix = 'Dirt'
    --then we could put it together as 'Base.Duffel_Dirt'
    -------------------------------------------------------------------------------------------------------
    local item = playerInv:getBestEvalArgRecurse(predicateTypeNotFull, comparatorMostFull, fullType)
    if not item then
        item = playerInv:getFirstEvalRecurse(predicateEmpty)
    end

    if item_name == "Duffel Bag" then fullType = "Base.Duffel_Dirt" end
    print("fullType is: " .. fullType)
    return fullType,item
end
---------------- 

--------------------------------------
-- if we overwrite start we'll need to adjust the jobtypes object
---[[
local old_SG_start = ISShovelGround.start
ISShovelGround.start = function(self)
    --I can do the below line, but not with newBag for some reason?
    local bagType = self.emptyBag:getName()
    print("empty bag:")
    print(self.emptyBag:getName())
    print("new bag:")
    print(self.newBag)
    

    local jobTypes = {}
    if bagType == "Duffel Bag" then
        jobTypes = {
            ["Base.Duffel_Dirt"] = "ContextMenu_Take_some_dirt",
            ["Base.Duffel_Gravel"] = "ContextMenu_Take_some_gravel",
            ["Base.Duffel_Sand"] = "ContextMenu_Take_some_sands"
        }
    else jobTypes = {
            ["Base.Dirtbag"] = "ContextMenu_Take_some_dirt",
            ["Base.Gravelbag"] = "ContextMenu_Take_some_gravel",
            ["Base.Sandbag"] = "ContextMenu_Take_some_sands"
        }
    end
    self.emptyBag:setJobType(getText(jobTypes[self.newBag]))
--    self.sound = getSoundManager():PlayWorldSound("shoveling", self.sandTile:getSquare(), 0, 5, 1, true);
    self:setActionAnim(ISFarmingMenu.getShovelAnim(self.character:getPrimaryHandItem()))
    self.sound = self.character:getEmitter():playSound("Shoveling")
    addSound(self.character, self.character:getX(), self.character:getY(), self.character:getZ(), 10, 1)
    return self
end
--]]