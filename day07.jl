depths = open("crabs.txt") do f
    parse.(Int, split(readline(f), ","))
end

# println(minimum(collect(i -> sum(map(x -> abs(x - i), depths)), collect(minimum(depths):maximum(depths)))))

min_fuel = Inf
for i in minimum(depths):maximum(depths)
    fuel = sum(map(x -> abs(x - i), depths))
    if fuel < min_fuel
        global min_fuel = fuel
    end
end

println(min_fuel)