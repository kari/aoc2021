initial_polymer, pairs = open("polymers.txt") do f
    polymer = only.(split(readline(f), ""))
    readline(f)
    pairs = Dict(map(x -> [only(x[1]), only(x[2])] => only(x[3]), map(r -> match(r"(\w)(\w) -> (\w)", r).captures, readlines(f))))
    polymer, pairs
end


polymer = join(initial_polymer)
for i in 1:10
    global polymer
    inserts = []
    for i in 1:length(polymer)-1
        # println("[$(polymer[i]),$(polymer[i+1])] => $(pairs[[polymer[i],polymer[i+1]]])")
        push!(inserts, pairs[[polymer[i],polymer[i+1]]])
    end
    polymer = join(Iterators.flatten(zip(polymer, inserts))) * polymer[end]
    # println(i, " ", length(polymer), " ", polymer)
end

counts = Dict([i => count(x -> x == i, polymer) for i in unique(polymer)])

println(maximum(values(counts)) - minimum(values(counts)))

# part 2: track pairs, each pair spawns two new pairs
polymer_pairs = Dict{Vector{Char}, Int}()
for p in map((x,y) -> [x, y], initial_polymer[1:end-1], initial_polymer[2:end])
    global polymer_pairs
    if haskey(polymer_pairs, p)
        polymer_pairs[p] += 1
    else
        polymer_pairs[p] = 1
    end
end
# println(polymer_pairs)

for i in 1:40
    global polymer_pairs, pairs
    new_pairs = Dict{Vector{Char}, Int}()
    for (key, value) in polymer_pairs
        el = pairs[key]
        for k in [[key[1], el], [el, key[2]]]
            if haskey(new_pairs, k)
                new_pairs[k] += value
            else
                new_pairs[k] = value
            end
        end
    end
    polymer_pairs = new_pairs
end

counts = Dict{Char, Int}()
for (key,value) in polymer_pairs
    global counts
    for k in key
        if haskey(counts, k)
            counts[k] += value
        else
            counts[k] = value
        end
    end
end

println(ceil(Int, maximum(values(counts))/2) - ceil(Int, minimum(values(counts))/2))
