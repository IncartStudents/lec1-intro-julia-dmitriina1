
module GameOfLife
using Plots

mutable struct Life
    current_frame::Matrix{Int}
    next_frame::Matrix{Int}
end

function step!(state::Life)
    current = state.current_frame
    next = state.next_frame

    #=
    TODO: вместо случайного шума
    реализовать один шаг алгоритма "Игра жизнь"
    =#
    next .= current
    n, m = size(current)
    for i in 1:length(current)
        row, col = Tuple(CartesianIndices(current)[i])
        neighbors = 0
        for i in -1:1, j in -1:1
            (i == 0 && j == 0) && continue
            neighbors += current[mod1(row + i, n), mod1(col + j, m)]
        end
        next[row, col] = (current[row, col] == 1) ? ((neighbors == 2 || neighbors == 3) ? 1 : 0) : ((neighbors == 3) ? 1 : 0)
    end
    for k in 1:length(current)
        current[k] = rand(0:1)
    end
    state.current_frame, state.next_frame = next, current

    # Подсказка для граничных условий - тор:
    # julia> mod1(10, 30)
    # 10
    # julia> mod1(31, 30)
    # 1

    return nothing
end

function (@main)(ARGS)
    n = 30
    m = 30
    init = rand(0:1, n, m)

    game = Life(init, zeros(n, m))

    anim = @animate for time = 1:100
        step!(game)
        cr = game.current_frame
        heatmap(cr)
    end
    gif(anim, "life.gif", fps = 10)
end

export main

end

using .GameOfLife
GameOfLife.main("")
