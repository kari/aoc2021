state = open("lanternfish.txt") do f
    parse.(Int, split(readline(f), ","))
end

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