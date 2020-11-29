
-- beds are of special intrest for mobs in some situations (they can sleep there)

-- node names of nodes that are beds
handle_schematics.bed_node_names = {
	['cottages:bed_head']=1,
	['beds:bed_top']=1,
	['beds:fancy_bed_top']=1,
	['cottages:sleeping_mat_head']=1};

-- content ids of nodes that are beds
handle_schematics.bed_content_ids = {};
for k,v in pairs( handle_schematics.bed_node_names ) do
	node_or_replacement = handle_schematics.node_defined( k );
	if node_or_replacement then
		content_id = minetest.get_content_id( node_or_replacement.name );
		handle_schematics.bed_content_ids[ content_id ] = 1;
	end
end
