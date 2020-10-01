
-- Note: If you are using handle_schematics.global_replacement_table, please also take into
--       account that you might have to add nodes to other tables, in particular:
--          * handle_schematics.direct_instead_of_drop
--          * handle_schematics.player_can_provide
--          * handle_schematics.bed_node_namess
--          * call handle_schematics.add_mirrored_node_type(..) where needed

-- allows to store global replacements (needed for subgames that do not provide a default mod)
handle_schematics.global_replacement_table = {};

handle_schematics.replace_global = function( node_name )
	if( not( node_name )) then
		return;
	end
	if( handle_schematics.global_replacement_table[ node_name ] ) then
		return handle_schematics.global_replacement_table[ node_name ];
	end
	return node_name;
end

handle_schematics.node_defined = function( node_name )
	if( not( node_name ) or node_name == "" ) then
		return;
	end
	if( handle_schematics.global_replacement_table[ node_name ] ) then
		return minetest.registered_nodes[ handle_schematics.global_replacement_table[ node_name ]];
	end
	return minetest.registered_nodes[ node_name ];
end


-- this is mostly for the build chest so that the final material beeing used can be shown
handle_schematics.apply_global_replacements = function(replacements, nodenames)
	-- change existing replacements where needed
	for i, repl in ipairs(replacements) do
		if(handle_schematics.global_replacement_table[ repl[2] ]) then
			replacements[i][2] = handle_schematics.global_replacement_table[ repl[2] ]
		end
	end
	-- add replacement for nodenames that are not yet covered
	for k, name in ipairs(nodenames) do
		-- if the node is to be replaced
		if(handle_schematics.global_replacement_table[name]) then
			local found = false
			for i, repl in ipairs(replacements) do
				if(repl[1] == name) then
					found = true
					break
				end
			end
			if(not(found)) then
				table.insert(replacements, {name, handle_schematics.global_replacement_table[name]})
			end
		end
	end
	return replacements
end


-- Some materials come in replacement groups, i.e. wood, roofs and farming. With this function,
-- you can not only replace the wood itself but also tree trunk, sapling, stairs etc. so that they
-- all fit the new material. Roof changes all roof-related nodes, and farming changes all growth
-- stages of a plant.
-- Parameters:
-- 	replacements	the current list of replacements; more may be added by this function
-- 	material_type	currently wood, roof or farming
-- 	old_material	i.e. default:wood, default:junglewood etc.
-- 	new_materail	if empty: select a random one; else use this as the target material
-- Returns:
-- 	Basic node name of the selected replacement.
handle_schematics.replace_material = function( replacements, material_type, old_material, new_material)
	-- do not replace anything if no group exists for it
	if( not(replacements_group[ material_type ])) then
		return old_material
	end
	-- this is a way to avoid replacements (for replace_randomized)
	if( new_material == "" ) then
		return old_material
	end
	-- if new_material is not given or does not exist, randomly select a new one
	if( not( new_material ) or not( minetest.registered_nodes[ new_material ])) then
		new_material =  replacements_group[ material_type ].found[
			math.random( 1, #replacements_group[ material_type ].found )];
	end
	if( not( old_material )) then
		if(     material_type == 'wood') then
			old_material = 'default:wood'
		elseif( material_type == 'roof') then
			old_material = 'cottages:roof_connector_straw'
		elseif( material_type == 'farming') then
			old_material = 'farming:cotton'
		end
	end
	if( new_material == old_material ) then
		return old_material
	end
	replacements_group[ material_type ].replace_material( replacements, old_material, new_material);
	return new_material
end


-- applies all necessary replacements:
--  * discontinued chests from cottages
--  * changed nodes in minetest_game such as doors etc.
--  * user-defined global replacements
--  * adjustments for realtest
--  * replaces wood, roof and plant (cotton) by the materials provided in
--    new_materials. If new_materials is empty, random replacements will used.
--    Structure of new_materials = {"wood":new_wood_material,
--      "roof":new_roof_material, "farming":new_cotton_replacement}
-- (currently only used by handle_schematics/detect_flat_land_fast.lua)
handle_schematics.replace_randomized = function( replacements, new_materials )

	if( not( replacements )) then
		replacements = {};
	end
	if( not( new_materials )) then
		new_materials = {};
	end
	-- these chests from cottages exist no longer
	table.insert( replacements, {"cottages:chest_private", "default:chest"});
	table.insert( replacements, {"cottages:chest_work",    "default:chest"});
	table.insert( replacements, {"cottages:chest_storage", "default:chest"});

	-- replace the wood
	handle_schematics.replace_material( replacements, 'wood',    nil, new_materials['wood'])
	-- change the roof to a random material
	handle_schematics.replace_material( replacements, 'roof',    nil, new_materials['roof'])
	-- grow random fruit instead of just cotton
	handle_schematics.replace_material( replacements, 'farming', nil, new_materials['farming'])

	return handle_schematics.apply_global_replacements(replacements)
end


-- makes sure all global replacements (including those from MineClone2 and those
-- from RealTest) are added to the list of replacements
handle_schematics.apply_global_replacements = function(replacements)
	-- if this is the subgame realtest then apply the necessary replacements;
	-- handle_schematics.is_realtest is set in init.lua of handle_schematics,
	-- depending on mods installed and found in RealTest
	if( handle_schematics.is_realtest ) then
		replacements = replacements_group['realtest'].replace( replacements );
	end

	-- we need to add global replacements - but only for those nodes that have not been
	-- replaced yet
	local as_table = {}
	for i, v in ipairs( replacements ) do
		as_table[ v[1] ] = v[2]
	end
	-- support global replacements
	for old_material, new_material in pairs( handle_schematics.global_replacement_table ) do
		-- only replace materials that have not yet been replaced
		if(not(as_table[old_material])) then
			-- if there is already a replacement for the new material: remember that and
			-- replace old_material into this new one
			if(not(as_table[new_material])) then
				table.insert( replacements, {old_material, new_material} )
			else
				table.insert( replacements, {old_material, as_table[new_material]} )
			end
		end
	end

	return replacements;
end


handle_schematics.set_node_is_ground = function(data, value)
	local c_ignore = minetest.get_content_id( 'ignore' );
	-- none of the nodes in the data table count as ground
	for _,v in ipairs( data ) do
		local real_name = minetest.registered_aliases[ v ];
		if(not(real_name)) then
			real_name = v;
		end
		if(real_name and real_name ~= "" and minetest.registered_nodes[ real_name ]) then
			local id = minetest.get_content_id( real_name );
			if( id and id ~= c_ignore ) then
				replacements_group.node_is_ground[ id ] = value;
			end
		end
	end
end


-- just some examples for testing:
--handle_schematics.global_replacement_table[ 'default:wood' ] = 'default:mese';
--handle_schematics.global_replacement_table[ 'stairs:stair_wood' ] = 'default:diamondblock';

-- many people prefer the new 3d torch even if it will melt some snow
handle_schematics.global_replacement_table[ 'mg_villages:torch' ] = 'default:torch';

-- for the mg mapgen
if(minetest.registered_nodes['default:mg_water_source']) then
	handle_schematics.global_replacement_table[ 'default:water_source' ] = 'default:mg_water_source';
end
