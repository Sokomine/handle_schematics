-- doors went through a lot of changes in the past
local door_types = {'wood', 'steel', 'glass', 'obsidian'}
for i, door_typ in ipairs(door_types) do
	local door_name = 'doors:door_'..door_typ
	-- the upper part is no longer a seperate part
	handle_schematics.global_replacement_table[ door_name..'_t_1' ] = 'doors:hidden'
	handle_schematics.global_replacement_table[ door_name..'_t_2' ] = 'doors:hidden'
	-- the lower part is now two nodes high
	handle_schematics.global_replacement_table[ door_name..'_b_1' ] = door_name..'_a'
	handle_schematics.global_replacement_table[ door_name..'_b_2' ] = door_name..'_b'
end
