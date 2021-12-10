cave = open("caves.txt") do f
    s = readlines(f)
    dims = (length(s[1]), length(s))
    v = parse.(Int, split(join(s), ""))
    reshape(v, dims)
end

local_mins = Vector{CartesianIndex}()
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

basins = Vector{Vector{CartesianIndex}}()
for local_min in local_mins
    global basins
    basin = Vector{CartesianIndex}()
    queue = [local_min]
    while length(queue) > 0
        p = popfirst!(queue)
        push!(basin, p)
        x, y = Tuple(p)
        if x > 1 && cave[x - 1, y] < 9
            push!(queue, CartesianIndex(x - 1, y))
        end
        if y > 1 && cave[x, y - 1] < 9
            push!(queue, CartesianIndex(x, y - 1))
        end
        if x < size(cave, 1) && cave[x + 1, y] < 9
            push!(queue, CartesianIndex(x + 1, y))
        end
        if y < size(cave, 2) && cave[x, y + 1] < 9
            push!(queue, CartesianIndex(x, y + 1))
        end
        queue = setdiff(unique(queue), basin)
    end
    push!(basins, basin)
end

println(prod(sort(map(x -> length(x), basins))[end-2:end]))
