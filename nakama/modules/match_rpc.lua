local nakama = require("nakama")

local Exceptions = {
    INVALID_MATCH_CODE = -1,
    INVALID_MATCH_ID = 3,
    USER_ALREADY_LOGGED_IN = 5,
}

local function get_match_code(match_id)
    return string.upper(string.sub(match_id, 1, 8))
end

local function get_match_id(_context, payload)
    local limit = 50
    local isAuthoritative = true
    local label = "Game match"
    local min_size = 0
    local max_size = 2
    local matches = nakama.match_list(limit, isAuthoritative, label, min_size, max_size)
    for _, match in ipairs(matches) do
        local match_code = get_match_code(match.match_id)
        if match_code == payload then
            return nakama.json_encode(match.match_id)
        end
    end
    return nakama.json_encode(Exceptions.INVALID_MATCH_CODE)
end

local function create_match(_context, _json_payload)
    local match_id = nakama.match_create("match_control", {})
    local match_code = get_match_code(match_id)
    return nakama.json_encode({match_code = match_code, match_id = match_id})
end

nakama.register_rpc(get_match_id, "get_match_id")
nakama.register_rpc(create_match, "create_match")