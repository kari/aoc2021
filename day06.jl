initial_state = open("lanternfish.txt") do f
    parse.(Int, split(readline(f), ","))
end

state = copy(initial_state)
# println("Intial sate: ", join(state, ","))
for i in 1:80
    global state = state .- 1
    if count(s -> s < 0, state) > 0
        append!(state, repeat([8], count(s -> s < 0, state)))
        state[state .< 0] .= 6
    end
    # println("After $(i) days: ", join(state, ","))
end

println(length(state))

buckets = zeros(Int, 9)
for s in initial_state
    buckets[s+1] += 1
end
# println(join(buckets, ","))

for i in 1:256
    global buckets = circshift(buckets, -1)
    buckets[7] += buckets[9]
    # println(i,": ",join(buckets, ","), " ", sum(buckets))
end
println(sum(buckets))