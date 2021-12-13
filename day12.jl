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

paths = []
explore("start", [], caves)
println(length(paths))

# TODO: choose one that can be used twice and iterate over all paths, add to previous paths, get uniques
