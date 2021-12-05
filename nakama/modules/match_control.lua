local nakama = require("nakama")

local match_control = {}

local OpCodes = {
    do_spawn = 1,
    player_joined = 2,
    player_left = 3,
    request_player_spells = 4,
    player_spells = 5,
    request_available_spells = 6,
    available_spells = 7,
    request_spell_queue = 8,
    spell_queue = 9,
    send_ready_to_start_state = 10,
    start_simulation = 11,
    send_pass_turn = 12,
    your_turn = 13,
    other_player_ready = 14,
}

local commands = {}

commands[OpCodes.do_spawn] = function(data, state, user_id)
    state.ready_vote[user_id] = data.ready
    if not data.spells then
        error("A lista de feiticos não pode ser nula.", 3)
        return
    end

    state.available_spells[state.user_types[user_id]] = data.spells
end

commands[OpCodes.request_player_spells] = function(data, state, user_id)
end

commands[OpCodes.request_available_spells] = function(data, state, user_id)
end

commands[OpCodes.request_spell_queue] = function(data, state, user_id)
end

commands[OpCodes.send_ready_to_start_state] = function(data, state, user_id)
    state.spell_queue = data.spell_queue or state.spell_queue
    state.ready_vote[user_id] = data.ready
end

commands[OpCodes.send_pass_turn] = function(data, state, user_id)
    state.spell_queue = data.spell_queue
end

function match_control.match_init(context, params)
    params = params or {}
    local state = {
        presences = {count = 0},
        user_types = {},
        usernames = {},
        available_spells = {},
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

local function find_other_sender(state, sender_id)
    for user_id, presence in pairs(state.presences) do
        if not (user_id == sender_id) and type(presence) == "table" then
            return presence
        end
    end
end

function match_control.match_join(context, dispatcher, tick, state, presences)
    for _, presence in ipairs(presences) do
        local user_id = presence.user_id

        state.presences[user_id] = presence
        state.presences.count = state.presences.count + 1
        state.user_types[user_id] = state.presences.count
        state.usernames[user_id] = presence.username
        state.ready_vote[user_id] = false
        state.sandbox_vote[user_id] = false

        dispatcher.broadcast_message(OpCodes.player_joined, nakama.json_encode(state.presences.count))
    end

    return state
end

function match_control.match_leave(context, dispatcher, tick, state, presences)
    for k, presence in ipairs(presences) do
        local user_id = presence.user_id
        state.presences.count = state.presences.count - 1
        for key, _ in pairs(state) do
            state[key][user_id] = nil
        end
    end

    -- if no one is present, terminates the match
    dispatcher.broadcast_message(OpCodes.player_left, nakama.json_encode(state.presences.count))
    return next(state.presences) and state???
end

function match_control.match_loop(context, dispatcher, tick, state, messages)
    for _, message in ipairs(messages) do
        local op_code = message.op_code
        local command = commands[op_code]
        local data = message.data
        local sender_id = message.sender.user_id
        if command then
            if data and string.len(data) > 0 then
                data = nakama.json_decode(data)
            else
                data = {}
            end

            command(data, state, sender_id)

            if op_code == OpCodes.do_spawn then
                local ready_count = 0
                for _, ready in pairs(state.ready_vote) do
                    if ready then
                        ready_count = ready_count + 1
                    end
                end
                if ready_count < 2 then
                    return state
                end
                state.ready_vote = {}
                dispatcher.broadcast_message(
                    OpCodes.available_spells,
                    nakama.json_encode(
                        {
                            player_a_spells = state.available_spells[1],
                            player_b_spells = state.available_spells[2]
                        }
                    )
                )
            elseif op_code == OpCodes.request_available_spells then
                dispatcher.broadcast_message(
                    OpCodes.available_spells,
                    nakama.json_encode(
                        {
                            player_a_spells = state.available_spells[1],
                            player_b_spells = state.available_spells[2]
                        }
                    ),
                    {message.sender}
                )
            elseif op_code == OpCodes.request_spell_queue then
                dispatcher.broadcast_message(
                    OpCodes.spell_queue,
                    nakama.json_encode(state.spell_queue),
                    {message.sender}
                )
            elseif op_code == OpCodes.send_ready_to_start_state then
                dispatcher.broadcast_message(OpCodes.other_player_ready,
                    nakama.json_encode(state.ready_vote[sender_id]),
                    {find_other_sender(state, sender_id)})
                local ready_count = 0
                for _, ready in pairs(state.ready_vote) do
                    if ready then
                        ready_count = ready_count + 1
                    end
                end
                if ready_count < 2 then
                    return state
                end
                state.ready_vote = {}
                dispatcher.broadcast_message(OpCodes.start_simulation, nakama.json_encode(state.spell_queue))
            elseif op_code == OpCodes.send_pass_turn then
                dispatcher.broadcast_message(
                    OpCodes.your_turn,
                    nakama.json_encode(state.spell_queue),
                    {find_other_sender(state, sender_id)}
                )
            end
        end
    end
    return state
end

function match_control.match_terminate(context, dispatcher, tick, state, grace_seconds)
    return state
end

return match_control
