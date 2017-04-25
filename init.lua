
handle_schematics = {}

handle_schematics.modpath = minetest.get_modpath( "handle_schematics");

-- adds worldedit_file.* namespace
-- deserialize worldedit savefiles
dofile(handle_schematics.modpath.."/worldedit_file.lua")

-- uses handle_schematics.* namespace
-- reads and analyzes .mts files (minetest schematics)
dofile(handle_schematics.modpath.."/analyze_mts_file.lua") 
-- reads and analyzes worldedit files
dofile(handle_schematics.modpath.."/analyze_we_file.lua")
-- reads and analyzes Minecraft schematic files
dofile(handle_schematics.modpath.."/translate_nodenames_for_mc_schematic.lua")
dofile(handle_schematics.modpath.."/analyze_mc_schematic_file.lua")
-- handles rotation and mirroring
dofile(handle_schematics.modpath.."/rotate.lua")
-- count nodes, take param2 into account for rotation etc.
dofile(handle_schematics.modpath.."/handle_schematics_misc.lua") 

-- store and restore metadata
dofile(handle_schematics.modpath.."/save_restore.lua");
dofile(handle_schematics.modpath.."/handle_schematics_meta.lua");

-- uses replacements_group.* namespace
-- these functions are responsible for the optional dependencies; they check
-- which nodes are available and may be offered as possible replacements
replacements_group = {};
-- the replacement groups do add some non-ground nodes; needed by mg_villages
replacements_group.node_is_ground = {}
dofile(handle_schematics.modpath.."/replacements_discontinued_nodes.lua")
dofile(handle_schematics.modpath.."/replacements_wood.lua")
dofile(handle_schematics.modpath.."/replacements_realtest.lua")
dofile(handle_schematics.modpath.."/replacements_farming.lua")
dofile(handle_schematics.modpath.."/replacements_roof.lua")

-- transforms the replacement list into a table;
-- also creates a replacement if needed and replaces default:torch
dofile(handle_schematics.modpath.."/replacements_get_table.lua")


-- assume dirt to be a general placeholder for "something you can
-- walk on"; might be stone, other dirt types etc.; this also
-- accepts other dirt and sand types for dirt_with_grass
dofile(handle_schematics.modpath.."/dirt_is_not_always_dirt.lua")
-- actually enable it (if you do not want this function just set
-- handle_schematics.also_acceptable = {}  somewhere in your code
handle_schematics.enable_use_dirt_as_placeholder();

-- apart from dirt_with_grass, some other nodes may not be obtainable without
-- creative because their drop is diffrent from their node name (i.e grass,
-- farming, doors, ..)
dofile(handle_schematics.modpath.."/player_can_provide.lua")

-- uses build_chest.* namespace
-- a chest for spawning buildings manually
dofile(handle_schematics.modpath.."/build_chest.lua")
-- makes the replacements from replacements_group.* available to the build chest
dofile(handle_schematics.modpath.."/build_chest_handle_replacements.lua");
-- creates 2d previews of the schematic from left/right/back/front/top
dofile(handle_schematics.modpath.."/build_chest_preview_image.lua");
-- reads a file and adds the files listed there as menu entries
dofile(handle_schematics.modpath.."/build_chest_add_schems_from_file.lua");
-- locate schematics through directories
dofile(handle_schematics.modpath.."/build_chest_add_schems_by_directory.lua");

-- the main functionality of the mod;
-- provides the function handle_schematics.place_building_from_file
-- (and also place_buildings for mg_villages)
dofile(handle_schematics.modpath.."/place_buildings.lua")

-- dofile(handle_schematics.modpath.."/fill_chest.lua")

dofile(handle_schematics.modpath.."/nodes.lua")
