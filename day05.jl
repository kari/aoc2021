using LinearAlgebra

line_pattern = r"(\d+),(\d+) -> (\d+),(\d+)"
lines = open("lines.txt") do f
    map(p -> [[p[1], p[2]], [p[3], p[4]]], map(r -> parse.(Int, match(line_pattern, r).captures), readlines(f)))
end

max_x, max_y = 0, 0
for l in lines
    if l[1][1] > max_x
        global max_x = l[1][1]
    end
    if l[2][1] > max_x
        global max_x = l[2][1]
    end
    if l[1][2] > max_y
        global max_y = l[1][2]
    end
    if l[2][2] > max_y
        global max_y = l[2][2]
    end
end

ocean_floor = zeros(Int64, max_x+1, max_y+1)

lines = filter(l -> l[1][1] == l[2][1] || l[1][2] == l[2][2], lines)

for l in lines
    # println(l)
    p, q = l
    v = q - p
    d = floor(Int, sqrt(v[1]^2 + v[2]^2))
    angle = atan(v[1], v[2]) - atan(1, 0)
    # println(rad2deg(angle))
    for i in 0:d
        x = round.(Int, p + [cos(angle), -sin(angle)] * i)
        # println(x)
        ocean_floor[(x+[1,1])...] += 1
    end
end

println(count(x -> x >= 2, ocean_floor))