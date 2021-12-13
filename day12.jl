caves = open("paths.txt") do f
    map(x -> x.captures, match.(r"(\w+)-(\w+)", readlines(f)))
end

append!(caves, reverse.(filter(x -> !(x[1] == "start" || x[2] == "end"), caves)))

function explore(node, history, caves)
    global paths # FIXME
    push!(history, node)
    if node == "end"
        # println("at end with history [$(join(history, ","))]")
        push!(paths, history)
        return true
    end
    # println("at $(node) with path [$(join(history, ","))]")
    next_nodes =  map(x -> x[2], filter(x -> x[1] == node && x[2] ∉ filter(n -> lowercase(n) == n, history), caves))
    if isempty(next_nodes)
        # println("got stuck")
        return false
    end
    # println("possible next nodes $(join(next_nodes, ","))")
    for n in next_nodes
        explore(n, copy(history), caves)
    end
    return true
end

function eligible_nodes(node, history, caves, twice)
    next_nodes = map(x -> x[2], filter(x -> x[1] == node, caves)) # start from current node
    if count(x -> x == twice, history) >= 2
        visited_small = filter(x -> x == lowercase(x), history)
    else
        visited_small = filter(x -> x != twice && x == lowercase(x), history)
    end
    next_nodes = filter(x -> x ∉ visited_small, next_nodes)

    return next_nodes
end

function explore(node, history, caves, twice)
    global paths # FIXME
    push!(history, node)
    if node == "end"
        # println("at end with history [$(join(history, ","))]")
        push!(paths, history)
        return true
    end
    # println("at $(node) with path [$(join(history, ","))]")
    next_nodes =  eligible_nodes(node, history, caves, twice)
    if isempty(next_nodes)
        # println("got stuck")
        return false
    end
    # println("possible next nodes $(join(next_nodes, ","))")
    for n in next_nodes
        explore(n, copy(history), caves, twice)
    end
    return true
end

paths = []
explore("start", [], caves)
println(length(paths))

# TODO: choose one that can be used twice and iterate over all paths, add to previous paths, get uniques
small_caves = []
for c in caves
    global small_caves
    if lowercase(c[1]) == c[1] && c[1] ∉ small_caves && c[1] ∉ ["start", "end"]
        push!(small_caves, c[1])
    end
    if lowercase(c[2]) == c[2] && c[2] ∉ small_caves && c[2] ∉ ["start", "end"]
        push!(small_caves, c[2])
    end
end

for i in small_caves
    global paths
    explore("start", [], caves, i)
    unique!(paths)
end
println(length(paths))
