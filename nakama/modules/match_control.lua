local nakama = require("nakama")

local match_control = {}

local OpCodes = {
    do_spawn = 1,
    player_joined = 2,
    request_player_spells = 3,
    player_spells = 4,
    request_available_spells = 5,
    available_spells = 6,
    request_spell_queue = 7,
    spell_queue = 8,
    send_ready_to_start_state = 9,
    ready_state = 10,
    send_pass_turn = 11,
    your_turn = 12
}

local commands = {}

local function find_spell(table, spell)
    local index
    local spell_id = spell.spell_id

    for i, spell in ipairs(table) do
        if spell.spell_id == spell_id then
            index = i
            break
        end
    end

    return index
end

commands[OpCodes.do_spawn] = function(data, state)
    if not data.spells or not next(data.spells) then
        error("Envie ao menos um feitico", 3)
        return
    end

    for _i, spell in ipairs(data.spells) do
        local available_spell_index = find_spell(state.available_spells, spell)
        if not available_spell_index then
            -- user sent a name for a spell that does not exist
            -- throw a nice error
            error("Esse feitico nao existe!", 3)
        end

        --[[ TODO: Move user_spells assignment to match creation
        local user_spell_index = find_spell(state.user_spells[user_id], spell)
        if not user_spell_index then
            -- user sent a name for a spell that does not belong to them
            -- throw a nice error
            error("Esse feitico nao deve ser nomeado por voce!", 3)
        end

        state.user_spells[user_id][user_spell_index].spell_name = spell.spell_name
        --]]
        state.available_spells[available_spell_index].spell_name = spell.spell_name
    end
end

commands[OpCodes.player_spells] = function(data, state)
end

function match_control.match_init(context, params)
    params = params or {}
    local state = {
        presences = {count = 0},
        usernames = {},
        player_spells = params.player_spells or
            {
                {function_name = "F1", parameter_name = "P1"},
                {function_name = "F2", parameter_name = "P2"}
            },
        spell_queue = {},
        ready_vote = {},
        sandbox_vote = {}
    }
    local tick_rate = params.tick_rate or 10
    local label = params.label or "Game match"

    return state, tick_rate, label
end

function match_control.match_join_attempt(context, dispatcher, tick, state, presence, metadata)
    if state.presences[presence.user_id] ~= nil then
        return state, false, "User already logged in"
    end
    return state, true
end

function match_control.match_join(context, dispatcher, tick, state, presences)
    for _, presence in ipairs(presences) do
        local user_id = presence.user_id
        state.presences[user_id] = presence
        state.presences.count = state.presences.count + 1
        state.player_spells[user_id] = state.player_spells[state.presences.count]
        state.usernames[user_id] = presence.username
        state.ready_vote[user_id] = false
        state.sandbox_vote[user_id] = false
    end

    dispatcher.broadcast_message(OpCodes.player_joined, nakama.json_encode(state.presences.count))
    return state
end

function match_control.match_leave(context, dispatcher, tick, state, presences)
    for _, presence in ipairs(presences) do
        local user_id = presence.user_id
        for key, _ in pairs(state) do
            state[key][user_id] = nil
        end
    end

    -- if no one is present, terminates the match
    return next(state.presences) and state
end

function match_control.match_loop(context, dispatcher, tick, state, messages)
    for _, message in ipairs(messages) do
        local op_code = message.op_code
        local command = commands[op_code]
        local data = message.data
        if command and data and string.len(data) > 0 then
            data = nakama.json_decode(data)
        else
            data = {}
        end
        data.user_id = message.sender.user_id

        command(data, state)

        if op_code == OpCodes.do_spawn then
            dispatcher.broadcast_message(
                OpCodes.do_spawn,
                nakama.json_encode(
                    {
                        usernames = state.usernames,
                        ready_vote = state.ready_vote,
                        sandbox_vote = state.sandbox_vote,
                        spell_queue = state.spell_queue
                    }
                )
            )
        elseif op_code == OpCodes.player_spells then
            dispatcher.broadcast_message(
                OpCodes.player_spells,
                nakama.json_encode(state.user_spells[data.user_id]),
                {message.sender}
            )
        end
    end
    return state
end

function match_control.match_terminate(context, dispatcher, tick, state, grace_seconds)
    return state
end

return match_control
