grid = open("chiton.txt") do f
    hcat(map(row -> parse.(Int, split(row, "")), readlines(f))...)
end

function dijkstra(graph, source, target)
    Q = []
    dist = Dict()
    prev = Dict()

    for v in CartesianIndices(graph)
        dist[v] = Inf
        prev[v] = nothing
        push!(Q, v)   
    end

    dist[source] = 0

    while !isempty(Q)
        u = argmin(x -> dist[x], Q)
        # println("considering $(u)")

        filter!(x -> x != u, Q)

        if u == target
            break
        end

        x, y = Tuple(u)
        # x_range = max(x - 1, 1):min(x + 1, size(graph, 1))
        # y_range = max(y - 1, 1):min(y + 1, size(graph, 2))
        # # println("considering neighbors $(x_range), $(y_range)")
        # neighbors = filter(x -> x in Q, CartesianIndices(graph)[x_range, y_range])
        neighbors = []
        if x > 1
            push!(neighbors, CartesianIndex(x-1, y))
        end
        if y > 1
            push!(neighbors, CartesianIndex(x, y-1))
        end
        if x < size(graph, 1)
            push!(neighbors, CartesianIndex(x+1, y))
        end
        if y < size(graph, 2)
            push!(neighbors, CartesianIndex(x, y+1))
        end
        # println(neighbors)
        for v in neighbors
            # println("considering neighbor $(v), $(dist[u] + graph[v]) < $(dist[v])")
            alt = dist[u] + graph[v]
            if alt < dist[v]
                dist[v] = alt
                prev[v] = u
            end
        end
    end

    return dist, prev
end

function shortest_path(prev, source, target)
    S = []
    u = target
    if prev[u] !== nothing || u == source
        while u !== nothing
            pushfirst!(S, u)
            u = prev[u]
        end
    end

    return S    
end

source = CartesianIndex(1,1)
target = CartesianIndex(size(grid, 1), size(grid, 2))
dist, prev = dijkstra(grid, source, target)
S = shortest_path(prev, source, target)
# for i in 1:size(grid, 2)
#     for j in 1:size(grid, 1)
#         if CartesianIndex(j, i) in S
#             print('X')
#         else
#             print(grid[j, i])
#             # print(' ')
#         end
#     end
#     println()
# end
sum = 0
for i in filter(x -> x != source, S)
    global sum, grid
    sum += grid[i]
end
println(sum)
