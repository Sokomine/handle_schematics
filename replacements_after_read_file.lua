
replacements_group["after_read_file"] = {}

-- Some mods (like i.e. moreblocks) define aliasses for nodes.
-- Schematics are saved with those aliassed names. When we want to restore such a
-- schematic, it has "wrong" node names (alias_name) stored ("wrong" in the sense
-- of "mod not installed in this world" or "replacements expect other name").
--
-- The replacements here are applied directly in handle_schematics.analyze_file(..)
-- and do not have to be applied manually.
--
handle_schematics.replacements_revert_alias = function( orig_node_name, alias_name )
	-- no problem if older definitions are overwritten
	-- (lets just hope the most recent one is the best one)
	replacements_group["after_read_file"][ alias_name ] = orig_node_name
end
