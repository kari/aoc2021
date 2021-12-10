nav = open("navigation.txt") do f
    readlines(f)
end

syntax_points = Dict(')' => 3, ']' => 57, '}' => 1197, '>' => 25137)
autocomplete_points = Dict(')' => 1, ']' => 2, '}' => 3, '>' => 4)
opposite = Dict(')' => '(', ']' => '[', '}' => '{', '>' => '<')
ropposite = Dict(v => k for (k,v) in opposite)

syntax_score = 0
autocomplete_scores = []
for line in nav
    global syntax_score, autocomplete_score
    syntax_error = false
    # println("new line")
    stack = Vector{Char}()
    for i in line[1:end]
        if i in keys(opposite)
            if !isempty(stack) && stack[end] == opposite[i]
                pop!(stack)
                # println("closing $(opposite[i]) ", join(stack))
            else
                # println("syntax error at $(i), expecting $(stack[end])")
                syntax_score += syntax_points[i]
                syntax_error = true
                break
            end
        else
            push!(stack, i)
            # println("adding $(i) to stack ", join(stack))
        end
    end
    if !isempty(stack) && !syntax_error
        # println("line incomplete ", map(x -> ropposite[x], reverse(join(stack))))
        score = 0
        for i in map(x -> ropposite[x], reverse(join(stack)))
            score = score * 5 + autocomplete_points[i]
        end
        push!(autocomplete_scores, score)
    end
end

sort!(autocomplete_scores)
println(syntax_score)
println(autocomplete_scores[ceil(Int, length(autocomplete_scores)/2)])
