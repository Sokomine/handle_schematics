-- handle_schematics does a lot more than just read schematics and place
-- them on the map; there are such things as biome conservation (includig
-- snow), replacements, scaffolding etc.;
--
-- this here provides interface functions so that generator functions that
-- would normally operate on a VoxelManip area (or on the map directly) can
-- provide structures for handle_schematics

-- helper function that emulates the function VoxelManip:set_node_at
handle_schematics.fake_vm_set_node_at = function( self, p, node )
	-- range check: self.scm_data_cache is prepared so that self.scm_data_cache[y][x]
	--              is valid for valid p.x and p.y; 
	if( p.z<1 or not(self.scm_data_cache[p.y]) or not(self.scm_data_cache[p.y][p.x])) then
		return;
	end
	if(not(node.name)) then
		return;
	end
	-- a nil value would be problematic later on
	if( not(node.param2)) then
		node.param2 = 0;
	end
	-- translate nodename into id
	local id = -1;
	for i,name in ipairs(self.nodenames) do
		if( name==node.name ) then
			id = i;
		end
	end
	-- new node name
	if(id==-1) then
		id = #self.nodenames+1;
		self.nodenames[ id ] = node.name;
		-- is it necessary to call on_construct or after_place_node?
		local node_def = handle_schematics.node_defined( node.name );
		if( node_def and node_def.on_construct) then
			table.insert( self.on_constr, name_text );
		end
		if( node_def and node_def.after_place_node) then
			table.insert( self.after_place_node, name_text );
		end
	end
	-- bed positions may be of less intrest in generated houses;
	-- however, it can't hurt to store them anyway
	if( handle_schematics.bed_node_names[ node.name ]) then
		self.bed_count = self.bed_count + 1;
		table.insert( self.bed_list, {x=x, y=y, z=z, p2, id});
	end
	-- actually store the data in the data structure
	self.scm_data_cache[p.y][p.x][p.z] = {id, node.param2};
end

-- create a fake VoxelManipulator data structure for generator functions
handle_schematics.create_fake_vm = function(sizex, sizey, sizez)
	-- data structure as would be provided by analyze_mts_file
	local vm = { size = { x=sizex, y=sizey, z=sizez},
		scm="Procedurally generated structure", -- name of building
		sizex=sizex, sizez=sizez, ysize=sizey, sizey=sizey,
		nodenames = {},
		on_constr = {},
		after_place_node = {},
		rotated=0, orients = {0},
		burried=0, yoff=1, -- not burried
		scm_data_cache = {},
		bed_count = 0,
		bed_list = {} };

	-- prepare the table so that a schematic can be inserted
	for y = 1, sizey do
		vm.scm_data_cache[y] = {};
		for x = 1, sizex do
			vm.scm_data_cache[y][x] = {};
		end
	end
	-- coordinates in this fake VoxelManip area do not represent real map
	-- coordinates; the function using this data structure must not operate
	-- on any real map metadata or anything like that
	vm.is_fake_vm = true;

	-- main function to actually set any nodes
	vm.set_node_at = handle_schematics.fake_vm_set_node_at;

	return vm;
end
