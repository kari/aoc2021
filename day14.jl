polymer, pairs = open("polymers.txt") do f
    polymer = readline(f)
    readline(f)
    pairs = Dict(map(x -> [only(x[1]), only(x[2])] => only(x[3]), map(r -> match(r"(\w)(\w) -> (\w)", r).captures, readlines(f))))
    polymer, pairs
end

for i in 1:10
    global polymer
    inserts = []
    for i in 1:length(polymer)-1
        # println("[$(polymer[i]),$(polymer[i+1])] => $(pairs[[polymer[i],polymer[i+1]]])")
        push!(inserts, pairs[[polymer[i],polymer[i+1]]])
    end
    polymer = join(Iterators.flatten(zip(split(polymer, ""), inserts))) * polymer[end]
    # println(i, " ", polymer, " ", length(polymer))
end

counts = Dict([i => count(x -> x == i, polymer) for i in unique(polymer)])

println(maximum(values(counts)) - minimum(values(counts)))
