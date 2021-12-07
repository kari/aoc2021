line_pattern = r"(\d+),(\d+) -> (\d+),(\d+)"
lines = open("lines.txt") do f
    map(p -> [[p[1], p[2]], [p[3], p[4]]], map(r -> parse.(Int, match(line_pattern, r).captures), readlines(f)))
end

max_x = maximum(map(x -> max(x[1][1], x[2][1]), lines))
max_y = maximum(map(y -> max(y[1][2], y[2][2]), lines))

ocean_floor = zeros(Int64, max_x+1, max_y+1)

for l in filter(l -> l[1][1] == l[2][1] || l[1][2] == l[2][2], lines)
    # println(l)
    p, q = l
    v = q - p
    d = floor(Int, sqrt(v[1]^2 + v[2]^2))
    angle = atan(v[1], v[2]) - atan(1, 0)
    for i in 0:d
        x = round.(Int, p + [cos(angle), -sin(angle)] * i)
        # println(x)
        ocean_floor[(x+[1,1])...] += 1
    end
end

println(count(x -> x >= 2, ocean_floor))

for l in filter(l -> !(l[1][1] == l[2][1] || l[1][2] == l[2][2]), lines)
    # println(l)
    p, q = l
    v = q - p
    d = sqrt(v[1]^2 + v[2]^2)
    angle = atan(v[1], v[2]) - atan(1, 0)
    # println(rad2deg(angle), " ", d)
    x = copy(p)
    ocean_floor[(x+[1,1])...] += 1
    while x != q
        if rad2deg(angle) % 90 == 0            
            x += round.(Int, [cos(angle), -sin(angle)])
        else 
            x += round.(Int, [cos(angle), -sin(angle)]*sqrt(2))
        end
        # println(x)
        ocean_floor[(x+[1,1])...] += 1
    end
end

println(count(x -> x >= 2, ocean_floor))