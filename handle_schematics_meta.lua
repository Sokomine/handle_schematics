

handle_schematics.sort_pos_get_size = function( p1, p2 )
	local res = {x=p1.x, y=p1.y, z=p1.z,
			sizex = math.abs( p1.x - p2.x )+1,
			sizey = math.abs( p1.y - p2.y )+1,
			sizez = math.abs( p1.z - p2.z )+1};
	if( p2.x < p1.x ) then
		res.x = p2.x;
	end
	if( p2.y < p1.y ) then
		res.y = p2.y;
	end
	if( p2.z < p1.z ) then
		res.z = p2.z;
	end
	return res;
end


local handle_schematics_get_meta_table = function( pos, all_meta )
	local m = minetest.get_meta( pos ):to_table();
	local empty_meta = true;

-- TODO: do not save known nodes if they contain the same values as a default node of that type
--local n = minetest.get_node( pos );
	-- the inventory part contains functions and cannot be fed to minetest.serialize directly
	local invlist = {};
	for name, list in pairs( m.inventory ) do
		invlist[ name ] = {};
		for i, stack in ipairs(list) do
			if( not( stack:is_empty())) then
				invlist[ name ][ i ] = stack:to_string();
				empty_meta = false;	
			end
		end
	end
	-- the fields part at least is unproblematic
	if( empty_meta and m.fields ) then
		for k,v in pairs( m.fields ) do
			empty_meta = false;
		end
	end
						
	-- only 
	if( not( empty_meta )) then
-- TODO: use relative positions instead of absolute ones
		all_meta[ #all_meta+1 ] = { x=pos.x, y=pos.y, z=pos.z, fields = m.fields, inventory = invlist};
	end
end

-- reads metadata values from start_pos to end_pos and stores them in a file
-- if clear_meta is set, all metadata values will be deleted after saving,
-- making the area ready for new voxelmanip/schematic data
handle_schematics.save_meta = function( start_pos, end_pos, filename, clear_meta )
	local all_meta = {};

	if( minetest.find_nodes_with_meta ) then
		for _,pos in ipairs( minetest.find_nodes_with_meta( start_pos, end_pos )) do
			handle_schematics_get_meta_table( pos, all_meta );
		end
	else
		local p = handle_schematics.sort_pos_get_size( start_pos, end_pos );
		for x=p.x, p.x+p.sizex do
			for y=p.y, p.y+p.sizey do
				for z=p.z, p.z+p.sizez do
					handle_schematics_get_meta_table( {x=x, y=y, z=z}, all_meta );
				end
			end
		end
	end

	if( #all_meta > 0 ) then
		save_restore.save_data( 'schems/'..filename..'.meta', all_meta );

		local empty_meta = { inventory = {}, fields = {} };
		for _, pos in ipairs( all_meta ) do
			local meta = minetest.get_meta( {x=pos.x, y=pos.y, z=pos.z} );
			meta:from_table( empty_meta );
		end	
	end
end


-- restore metadata from file
-- TODO: use relative instead of absolute positions
handle_schematics.restore_meta = function( filename )

	local all_meta = save_restore.restore_data( 'schems/'..filename..'.meta' );	
	for _,pos in ipairs( all_meta ) do
		local meta = minetest.get_meta( {x=pos.x, y=pos.y, z=pos.z} );
		meta:from_table( {inventory = pos.inventory, fields = pos.fields });
	end
end
