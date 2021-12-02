pattern = r"(\w+) (\d+)"
course = open("course.txt") do f
    match.(pattern, readlines(f))
end

pos = 0
depth = 0
for move in course
    if move[1] == "forward"
        global pos += parse(Int, move[2])
    elseif move[1] == "up"
        global depth -= parse(Int, move[2])
    elseif move[1] == "down"
        global depth += parse(Int, move[2])
    end
end

println(pos*depth)

pos = 0
depth = 0
aim = 0
for move in course
    if move[1] == "forward"
        global pos += parse(Int, move[2])
        global depth += aim * parse(Int, move[2])
    elseif move[1] == "up"
        global aim -= parse(Int, move[2])
    elseif move[1] == "down"
        global aim += parse(Int, move[2])
    end
end

println(pos*depth)
