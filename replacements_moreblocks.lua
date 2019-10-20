--
-- this is taken from Calinous moreblocks mod with his permission.
-- See original file here:
-- https://github.com/minetest-mods/moreblocks/blob/master/stairsplus/registrations.lua
--
-- We do need to revert the aliases defined there in moreblocks stairplus mod
-- because a) moreblocks might not be installed and b) replacement functions
-- expect node names in the stairs:* naming space.


-- default registrations
local default_nodes = { -- Default stairs/slabs/panels/microblocks:
	"stone",
	"stone_block",
	"cobble",
	"mossycobble",
	"brick",
	"sandstone",
	"steelblock",
	"goldblock",
	"copperblock",
	"bronzeblock",
	"diamondblock",
	"tinblock",
	"desert_stone",
	"desert_stone_block",
	"desert_cobble",
	"meselamp",
	"glass",
	"tree",
	"wood",
	"jungletree",
	"junglewood",
	"pine_tree",
	"pine_wood",
	"acacia_tree",
	"acacia_wood",
	"aspen_tree",
	"aspen_wood",
	"obsidian",
	"obsidian_block",
	"obsidianbrick",
	"obsidian_glass",
	"stonebrick",
	"desert_stonebrick",
	"sandstonebrick",
	"silver_sandstone",
	"silver_sandstone_brick",
	"silver_sandstone_block",
	"desert_sandstone",
	"desert_sandstone_brick",
	"desert_sandstone_block",
	"sandstone_block",
	"coral_skeleton",
	"ice",
}

for _, name in pairs(default_nodes) do
	local mod = "default"
	local nodename = mod .. ":" .. name
	mod = "moreblocks"
	handle_schematics.replacements_revert_alias("stairs:stair_" .. name, mod .. ":stair_" .. name)
	handle_schematics.replacements_revert_alias("stairs:stair_outer_" .. name, mod .. ":stair_" .. name .. "_outer")
	handle_schematics.replacements_revert_alias("stairs:stair_inner_" .. name, mod .. ":stair_" .. name .. "_inner")
	handle_schematics.replacements_revert_alias("stairs:slab_"  .. name, mod .. ":slab_"  .. name)
end

-- farming registrations
if minetest.get_modpath("farming") then
	local farming_nodes = {"straw"}
	for _, name in pairs(farming_nodes) do
		local mod = "farming"
		local nodename = mod .. ":" .. name

		mod = "moreblocks"
		handle_schematics.replacements_revert_alias("stairs:stair_" .. name, mod .. ":stair_" .. name)
		handle_schematics.replacements_revert_alias("stairs:stair_outer_" .. name, mod .. ":stair_" .. name .. "_outer")
		handle_schematics.replacements_revert_alias("stairs:stair_inner_" .. name, mod .. ":stair_" .. name .. "_inner")
		handle_schematics.replacements_revert_alias("stairs:slab_"  .. name, mod .. ":slab_"  .. name)
	end
end

-- basic_materials, keeping the original other-mod-oriented names
-- for backwards compatibility

if minetest.get_modpath("basic_materials") then
	handle_schematics.replacements_revert_alias("prefab:concrete_stair","technic:stair_concrete")
	handle_schematics.replacements_revert_alias("prefab:concrete_slab","technic:slab_concrete")
end
