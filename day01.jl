depths = open("depths.txt") do f
    parse.(Int, readlines(f))
end

println(count(map((x,y) -> y > x, depths[1:end-1], depths[2:end])))

depths_window = map((x,y,z) -> x+y+z, depths[1:end-2], depths[2:end-1], depths[3:end])

println(count(map((x,y) -> y > x, depths_window[1:end-1], depths_window[2:end])))
