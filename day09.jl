cave = open("caves.txt") do f
    s = readlines(f)
    dims = (length(s[1]), length(s))
    v = parse.(Int, split(join(s), ""))
    reshape(v, dims)
end

local_mins = []
for i in CartesianIndices(cave)
    global local_mins
    x, y = Tuple(i)
    p = cave[i]
    local_min = true
    if x > 1 && cave[x - 1, y] <= p
        local_min = false
    end
    if y > 1 && cave[x, y - 1] <= p
        local_min = false
    end
    if x < size(cave, 1) && cave[x + 1, y] <= p
        local_min = false
    end
    if y < size(cave, 2) && cave[x, y + 1] <= p
        local_min = false
    end
    if local_min
        push!(local_mins, i)
    end
end

println(sum(map(x -> cave[x] + 1, local_mins)))
