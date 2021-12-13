dots, folds = open("origami.txt") do f
    dots, folds = match(r"((?:\d+,\d+\n)+)\s+((?:fold along [yx]=\d+\n)+)", read(f, String)).captures
    dots = map(x -> parse.(Int, x), split.(split(strip(dots), "\n"), ","))
    folds =  map(x -> [only(x[1]), parse(Int, x[2])+1], eachmatch(r"([xy])=(\d+)", folds))
    max_x = maximum(map(x -> x[1], dots)) + 1
    max_y = maximum(map(x -> x[2], dots)) + 1
    m = zeros(Int, max_x, max_y)
    for d in dots
        m[d[1]+1, d[2]+1] = 1
    end
    m, folds
end

for f in folds[1:1]
    global dots
    if f[1] == 'y'
        a = dots[:, 1:f[2]-1]
        b = reverse(dots[:, f[2]+1:end], dims = 2)
    elseif f[1] == 'x'
        a = dots[1:f[2]-1, :]
        b = reverse(dots[f[2]+1:end, :], dims = 1)
    end
    dots = max.(a, b)
end

println(sum(dots))

for f in folds[2:end]
    global dots
    if f[1] == 'y'
        a = dots[:, 1:f[2]-1]
        b = reverse(dots[:, f[2]+1:end], dims = 2)
    elseif f[1] == 'x'
        a = dots[1:f[2]-1, :]
        b = reverse(dots[f[2]+1:end, :], dims = 1)
    end
    dots = max.(a, b)
end

for i in eachcol(dots)
    for j in i
        if j == 0
            print(' ')
        else
            print('#')
        end
    end
    println()
end
