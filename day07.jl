depths = open("crabs.txt") do f
    parse.(Int, split(readline(f), ","))
end

min_fuel = Inf
for i in minimum(depths):maximum(depths)
    fuel = sum(map(x -> abs(x - i), depths))
    if fuel < min_fuel
        global min_fuel = fuel
    end
end

println(min_fuel)

min_fuel = Inf
for i in minimum(depths):maximum(depths)
    fuel = sum(map(x -> abs(x - i)*(1+abs(x - i)) ÷ 2, depths))
    if fuel < min_fuel
        global min_fuel = fuel
    end
end

println(min_fuel)
