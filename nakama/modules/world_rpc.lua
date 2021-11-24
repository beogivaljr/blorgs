local nakama = require("nakama")

local matches = {}

local function get_world_id(_context, payload)
	local match_id = matches[payload]
    if match_id == nil then
        return -1
    else
        return match_id
    end
end

local function create_world(_context, _payload)	
	local match_id = nakama.match_create("world_control", {})
	local hash_code = string.sub(match_id, 1, 8)
	matches[hash_code] = match_id
	
	return hash_code
	
end
nakama.register_rpc(get_world_id, "get_world_id")
nakama.register_rpc(create_world, "create_world")
