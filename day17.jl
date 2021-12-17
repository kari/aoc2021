target_area = open("target_area.txt") do f
    x1,x2,y1,y2 = parse.(Int, match(r"x=(\d+)\.\.(\d+), y=([-\d]+)\.\.([-\d+]+)",readline(f)).captures)
    [x1:x2, y1:y2]
end

#target_area = [20:30, -10:-5]

@enum Result hit=0 overshot=1 undershot=2 miss=3
struct Shot
    result::Result
    max_y::Int
end

function fly(velocity::Vector{Int}, target_area::Vector{UnitRange{Int}})
    # println("target area x=$(target_area[1]), y=$(target_area[2])")
    # println("initial velocity ($(velocity[1]),$(velocity[2]))")
    pos = [0,0]
    path = [pos]
    max_y = 0
    while pos[1] <= maximum(target_area[1]) && pos[2] > minimum(target_area[2])
        pos = pos + velocity
        push!(path, pos)
        if pos[2] > max_y
            # println("new max y = $(pos[2])")
            max_y = pos[2]
        end
        if velocity[1] < 0 
            velocity += [1, -1]
        elseif velocity[1] > 0
            velocity -= [1, 1]
        else
            velocity -= [0, 1]
        end
        # println("position ($(pos[1]),$(pos[2])), velocity ($(velocity[1]),$(velocity[2]))")
        if pos[1] in target_area[1] && pos[2] in target_area[2]
            # println("IN TARGET AREA")
            return Shot(hit, max_y)
        elseif pos[1] > maximum(target_area[1])
            # println("OVERSHOT")
            return Shot(overshot, max_y)
        elseif pos[2] <= minimum(target_area[2])
            # println("UNDERSHOT")
            return Shot(undershot, max_y)
        end    
    end
    # println("MISS")
    # overshot or undershot on x?
    return Shot(miss, max_y)
end

min_x = 1
max_y = 0
for y in 0:1000
    global max_y
    hits = 0
    for x in maximum(target_area[1])-1:-1:min_x
        global min_x, global_max_y
        # println("shoot ($(x),$(y))")
        shot = fly([x,y], target_area)
        if shot.result == hit
            hits += 1
            if shot.max_y > max_y
                # println("new global max y = $(shot.max_y) with ($(x),$(y))")
                max_y = shot.max_y
            end
        elseif shot.result == undershot
            min_x = x
            break
        end
    end
end

println(max_y)
