initial_state = open("octopus.txt") do f
    reshape(parse.(Int, split(join(readlines(f)), "")), 10, 10)
end

state = copy(initial_state)
flashes = 0
for n in 1:100
    global flashes
    global state .+= 1

    while any(x -> x > 9, state)
        for i in findall(x -> x > 9, state)
            flashes += 1
            x, y = Tuple(i)
            state[i] = typemin(Int)
            x_range = max(x - 1, 1):min(x + 1, size(state, 1))
            y_range = max(y - 1, 1):min(y + 1, size(state, 2))
            state[x_range, y_range] .+= 1
        end
    end

    state = max.(state, 0)
end

println(flashes)

state = copy(initial_state)
for n in 1:1_000_000
    global state .+= 1

    while any(x -> x > 9, state)
        for i in findall(x -> x > 9, state)
            x, y = Tuple(i)
            state[i] = typemin(Int)
            x_range = max(x - 1, 1):min(x + 1, size(state, 1))
            y_range = max(y - 1, 1):min(y + 1, size(state, 2))
            state[x_range, y_range] .+= 1
        end
    end

    state = max.(state, 0)

    if all(x -> x == 0, state)
        println(n)
        break
    end
end
