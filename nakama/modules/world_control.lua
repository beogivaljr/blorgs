local world_control = {}

function world_control.match_init(context, params)
    local state = {
        presences = {}
    }
    local tick_rate = 10
    local label = "Game world"

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
        state.presences[presence.user_id] = presence
    end
    return state
end

function world_control.match_leave(context, dispatcher, tick, state, presences)
    for _, presence in ipairs(presences) do
        state.presences[presence.user_id] = nil
    end
    return state
end

function world_control.match_loop(context, dispatcher, tick, state, messages) --Ve o que ocorre no jogo na frequencia do tick_rate
    return state
end


function world_control.match_terminate(context, dispatcher, tick, state, grace_seconds)
    return state
end


return world_control