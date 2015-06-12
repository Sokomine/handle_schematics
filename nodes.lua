


---------------------------------------------------------------------------------------
-- helper node that is used during construction of a house; scaffolding
---------------------------------------------------------------------------------------

minetest.register_node("handle_schematics:support", {
        description = "support structure for buildings",
        tiles = {"handle_schematics_support.png"},
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
        walkable = false,
        climbable = true,
        paramtype = "light",
        drawtype = "plantlike",
})


minetest.register_craft({
	output = "handle_schematics:support",
	recipe = {
		{"default:stick", "", "default:stick", }
        }
})


---------------------------------------------------------------------------------------
-- a rope that is of use to the mines
---------------------------------------------------------------------------------------
-- TODO: give credit for the texture
-- the rope can only be digged if there is no further rope above it
minetest.register_node("handle_schematics:rope", {
        description = "rope for climbing",
        tiles = {"handle_schematics_rope.png"},
	groups = {snappy=3,choppy=3,oddly_breakable_by_hand=3,rail=1,connect_to_raillike=1},--connect_to_raillike=minetest.raillike_group("rail")},
        walkable = false,
        climbable = true,
        paramtype = "light",
        sunlight_propagates = true,
        drawtype = "plantlike",
	can_dig = function(pos, player)
			local below = minetest.get_node( {x=pos.x, y=pos.y-1, z=pos.z});
			if( below and below.name and below.name == "handle_schematics:rope" ) then
				if( player ) then
					minetest.chat_send_player( player:get_player_name(),
						'The entire rope would be too heavy. Start digging at its lowest end!');
				end
				return false;
			end
			return true;
		end
})

minetest.register_craft({
	output = "handle_schematics:rope",
	recipe = {
		{"default:string"}
        }
})

minetest.register_node("handle_schematics:ladder", {
	description = "Ladder with rail support",
	drawtype = "signlike",
	tiles = {"default_ladder.png^default_rail.png^handle_schematics_rope.png"},
	inventory_image = "default_ladder.png",
	wield_image = "default_ladder.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	climbable = true,
	is_ground_content = false,
	selection_box = {
		type = "wallmounted",
		--wall_top = = <default>
		--wall_bottom = = <default>
		--wall_side = = <default>
	},
	groups = {choppy=2,oddly_breakable_by_hand=3,rail=1,connect_to_raillike=1}, --connect_to_raillike=minetest.raillike_group("rail")},
	legacy_wallmounted = true,
	sounds = default.node_sound_wood_defaults(),
})



