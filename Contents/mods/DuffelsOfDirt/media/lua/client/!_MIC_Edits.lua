--[[ bundled with M's buckets. I haven't yet determined if I need this for what I'm trying to accomplish */ ]]--
require "BuildingObjects/ISUI/ISInventoryBuildMenu"
Events.OnFillWorldObjectContextMenu.Remove(ISInventoryBuildMenu.doBuildMenu)
