local nakama = require("nakama")

local match_ids = {}

local function get_match_id(_context, payload)
    local match_id = match_ids[payload]
    return match_id or "-1"
end

local function create_world(_context, json_payload)
    local payload = json_payload and string.len(json_payload) > 0 and nakama.json_decode(json_payload) or {}
    local match_id = nakama.match_create("match_control", payload)
    local hash_code = string.sub(match_id, 1, 8)
    hash_code = string.upper(hash_code)
    match_ids[hash_code] = match_id

    return hash_code
end

nakama.register_rpc(get_match_id, "get_match_id")
nakama.register_rpc(create_world, "create_world")
