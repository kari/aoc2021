nav = open("navigation.txt") do f
    readlines(f)
end

points = Dict(')' => 3, ']' => 57, '}' => 1197, '>' => 25137)
opposite = Dict(')' => '(', ']' => '[', '}' => '{', '>' => '<')

score = 0
for line in nav
    global score
    # println("new line")
    stack = Vector{Char}()
    for i in line[1:end]
        if i in keys(points)
            if isempty(stack)
                # println("syntax error at 1, line starts with closing")
                break
            elseif stack[end] == opposite[i]
                pop!(stack)
                # println("closing $(opposite[i]) ", join(stack))
            else
                # println("syntax error at $(i), expecting $(stack[end])")
                score += points[i]
                break
            end
        else
            push!(stack, i)
            # println("adding $(i) to stack ", join(stack))
        end
    end
    if !isempty(stack)
        # println("line incomplete")
    end
end
println(score)
