
-- "dirt" stands as a placeholder for "some ground node; can be stone or dirt or something similar";
handle_schematics.also_acceptable = {};

-- This function fills the table handle_schematics.also_acceptable with data.
-- The general assumption is that dirt nodes in schematics are most of the time just placeholders
-- and could as well be other nodes - like i.e. stone, stone with ore, other variants of dirt
-- etc.
-- This also applies to default:dirt_with_grass. There are very few situations where it *does*
-- have to be dirt_with_grass. Most of the time it will look much better if what was placed
-- there by mapgen is taken instead (i.e. the local dirt type, sand, gravel, ...)
handle_schematics.enable_use_dirt_as_placeholder = function()
	local dirt_id = minetest.get_content_id("default:dirt");
	handle_schematics.also_acceptable[ dirt_id ] = { is_ok = {}};
	local fill_nodes = {"default:stone","default:stone_with_coal","default:stone_with_iron",
		"default:stone_with_copper","default:stone_with_mese","default:stone_with_diamond",
		"default:stone_with_gold","default:stone_with_tin",
		"default:desert_stone","default:mese",
		"default:cobble","default:mossycobble","default:sandstone","default:silver_sandstone",
		-- falling nodes would be too problematic in this case;
		-- diffrent dirt types
		"default:dirt_with_dry_grass","default:dirt_with_grass","default:dirt_with_rainforest_litter",
		"default:dirt_with_snow", "default:snowblock","default:ice"};
	for i,v in ipairs( fill_nodes ) do
		local id = minetest.get_content_id( v );
		handle_schematics.also_acceptable[ dirt_id ].is_ok[ id ] = 1;
	end

	-- it does not always have to be dirt_with_grass
	dirt_id = minetest.get_content_id( "default:dirt_with_grass" );
	handle_schematics.also_acceptable[ dirt_id ] = { is_ok = {}};
	fill_nodes = {
		-- falling nodes...but may still be ok in this context
		"default:gravel","default:sand","default:desert_sand","default:silver_sand",
		-- diffrent dirt types
		"default:dirt_with_dry_grass","default:dirt_with_grass","default:dirt_with_rainforest_litter",
		"default:dirt_with_snow","default:dirt","default:snowblock","default:ice"};
	for i,v in ipairs( fill_nodes ) do
		local id = minetest.get_content_id( v );
		handle_schematics.also_acceptable[ dirt_id ].is_ok[ id ] = 1;
	end
end

