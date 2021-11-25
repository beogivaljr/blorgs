local nakama = require("nakama")

local world_control = {}

local OpCodes = {
    do_spawn = 1
}

local commands = {}

commands[OpCodes.do_spawn] = function(data, state)
    local user_id = data.sender.user_id
    state.names[user_id] = data.sender.username

    if not data.spells then
        error("Nenhum feitico a ser nomeado?", 3)
    end

    for spell_id, spell_name in pairs(data.spells) do
        if state.spells[user_id][spell_id] then
            state.spells[spell_id] = spell_name
        else
            -- user sent a name for a spell that does not belong to them
            -- throw a nice error
            error("Esse feitico nao deve ser nomeado por voce!", 3)
        end
    end
end

function world_control.match_init(context, params)
    params = params or {}
    local state = {
        presences = {},
        spells = params.spells or {},
        names = {}
    }
    local tick_rate = params.tick_rate or 10
    local label = params.label or "Game world"

    return state, tick_rate, label
end

function world_control.match_join_attempt(context, dispatcher, tick, state, presence, metadata)
    if state.presences[presence.user_id] ~= nil then
        return state, false, "User already logged in"
    end
    return state, true
end

function world_control.match_join(context, dispatcher, tick, state, presences)
    for _, presence in ipairs(presences) do
        local user_id = presence.user_id
        state.presences[user_id] = presence
        state.spells[user_id] = {state.spells[1]}
        state.names[user_id] = "Jogador"
    end
    return state
end

function world_control.match_leave(context, dispatcher, tick, state, presences)
    for _, presence in ipairs(presences) do
        local user_id = presence.user_id
        for key, _ in pairs(state) do
            state[key][user_id] = nil
        end
    end

    -- if no one is present, terminates the match
    return next(state.presences) and state
end

function world_control.match_loop(context, dispatcher, tick, state, messages)
    for message in messages do
        local op_code = message.op_code
        local command = commands[op_code]
        local data = message.data
        if command and data and string.len(data) > 0 then
            command(nakama.json_decode(data), state)
        end
    end
    return state
end

function world_control.match_terminate(context, dispatcher, tick, state, grace_seconds)
    return state
end

return world_control
