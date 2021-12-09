local nakama = require("nakama")

local match_ids = {}

local function get_match_id(_context, payload)
    local match_id = match_ids[payload]
    return match_id or "-1"
end

local function create_match(_context, _json_payload)
    local match_id = nakama.match_create("match_control", {})
    local hash_code = string.sub(match_id, 1, 8)
    hash_code = string.upper(hash_code)
    match_ids[hash_code] = match_id
    return hash_code
end

nakama.register_rpc(get_match_id, "get_match_id")
nakama.register_rpc(create_match, "create_match")
