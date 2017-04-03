


---------------------------------------------------------------------------------------
-- helper node that is used during construction of a house; scaffolding
---------------------------------------------------------------------------------------

-- this node can be crafted
minetest.register_node("handle_schematics:support", {
        description = "support structure for buildings",
        tiles = {"handle_schematics_support.png"},
	groups = {snappy=3,choppy=3,oddly_breakable_by_hand=3},
	visual_scale = 1.2,
        walkable = false,
        climbable = true,
        paramtype = "light",
        drawtype = "plantlike",
--	-- the small selection box allows the player to dig one or two nodes below
--	selection_box = {
--                type = "fixed",
--                fixed = {-2 / 16, -0.5, -2 / 16, 2 / 16, 0.5, 2 / 16}
--        },
})


minetest.register_craft({
	output = "handle_schematics:support 4",
	recipe = {
		{"group:stick", "", "group:stick" }
        }
})

-- this node will only be placed by spawning a house with handle_schematics
minetest.register_node("handle_schematics:support_setup", {
        description = "support structure for buildings (configured)",
        tiles = {"handle_schematics_support.png"},
	groups = {snappy=3,choppy=3,oddly_breakable_by_hand=3},
	visual_scale = 1.2,
        walkable = false,
        climbable = true,
        paramtype = "light",
        drawtype = "plantlike",
	-- after it is digged, the node looses its information and becomes a normal, unconfigured one
	drop = "handle_schematics:support",
	-- note: mobs that want to use this function ought to provide "clicker" in a way so that clicker:get_inventory
	--       can get used (at least if they want to have a limited inventory)
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
				if default.can_interact_with_node(clicker, pos) then
					local meta = minetest.get_meta( pos );
					local node_wanted = meta:get_string( "node_wanted" );
					local param2_wanted = meta:get_int( "param2_wanted" );

					if( not(meta) or not(node_wanted) or node_wanted == "" or not(clicker)) then
						return itemstack;
					end

					if( clicker and clicker.get_inventory) then
						local node_really_wanted = node_wanted;

						-- some nodes like i.e. dirt with grass or stone with coal cannot be obtained;
						-- in such a case we ask for the drop
						if(    minetest.registered_nodes[ node_wanted ]
						   -- provided the drop actually exists
						   and minetest.registered_nodes[ node_wanted ].drop
						   and minetest.registered_items[ minetest.registered_nodes[ node_wanted ].drop ]
						   -- stone, desertstone and clay can be obtained
						   and not( handle_schematics.direct_instead_of_drop[ node_wanted ])) then
							node_really_wanted = minetest.registered_nodes[ node_wanted ].drop;
						end

						if(not( clicker:get_inventory():contains_item("main", node_really_wanted ))) then
							if( clicker:is_player()) then
								minetest.chat_send_player( clicker:get_player_name(),
									"You have no "..( minetest.registered_nodes[ node_really_wanted ].description or "such node")..
									" ["..node_really_wanted.."].");
							end
							return itemstack;
						end
						-- give the player some feedback (might scroll a bit..)
						if( clicker:is_player()
						   and minetest.registered_nodes[ node_really_wanted ]
						   and minetest.registered_nodes[ node_really_wanted ].description) then
							minetest.chat_send_player( clicker:get_player_name(),
								"Placed "..( minetest.registered_nodes[ node_really_wanted ].description or node_really_wanted)..".");
						end
						-- take the item from the player (provided it actually is a player and not a mob)
						clicker:get_inventory():remove_item("main", node_really_wanted);
					end

					minetest.env:add_node( pos, { name =  node_wanted, param1 = 0, param2 = param2_wanted } );

				end
				return itemstack;
			end
})


-- no craft receipe for this node as it's only an indicator that the player shall dig here
minetest.register_node("handle_schematics:dig_here", {
	description = "dig the node below this one",
	tiles = {"default_tool_mesepick.png^[colorize:#FF0000^[transformFXR90"},
	inventory_image = "default_tool_mesepick.png^[colorize:#FF0000^[transformFXR90";
	-- falling node; will notice if the node below it is beeing digged; cannot be destroyed the normal way
	groups = {}, --{falling_node = 1},
	visual_scale = 0.6,
	walkable = false,
	climbable = true,
	paramtype = "light",
	drawtype = "torchlike",
	-- this node's purpose is to indicate that the player shall dig here;
	-- that requires beeing able to actually aim at that node below
	selection_box = {
                type = "fixed",
                fixed = {-2 / 16, -0.5, -2 / 16, 2 / 16, 6 / 16, 2 / 16}
        },

})
