
-- reserve the namespace
save_restore = {}

-- TODO: if this gets more versatile, add sanity checks for filename
-- TODO: apart from allowing filenames,  schems/<filename> also needs to be allowed

-- TODO: save and restore ought to be library functions and not implemented in each individual mod!
save_restore.save_data = function( filename, data )

	local path = minetest.get_worldpath()..'/'..filename;
	
	local file = io.open( path, 'w' );
	if( file ) then
		file:write( minetest.serialize( data ));
		file:close();
	else
		print("[save_restore] Error: Savefile '"..tostring( path ).."' could not be written.");
	end
end


save_restore.restore_data = function( filename )

	local path = minetest.get_worldpath()..'/'..filename;

	local file = io.open( path, 'r' );
	if( file ) then
		local data = file:read("*all");
		file:close();
		return minetest.deserialize( data );
	else
		print("[save_restore] Error: Savefile '"..tostring( path ).."' not found.");
		return {}; -- return empty table
	end
end



save_restore.file_exists = function( filename )

	local path = minetest.get_worldpath()..'/'..filename;

	local file = io.open( path, 'r' );
	if( file ) then
		file:close();
		return true;
	end
	return;
end


save_restore.create_directory = function( filename )

	local path = minetest.get_worldpath()..'/'..filename;

	if( not( save_restore.file_exists( filename ))) then
		if( minetest.mkdir ) then
			minetest.mkdir( minetest.get_worldpath().."/schems".. "\"");
		else
			os.execute("mkdir \""..minetest.get_worldpath().."/schems".. "\"");
		end
	end
end
