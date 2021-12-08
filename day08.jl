pattern = r"((?:[a-g]+ ?)+) \| ((?:[a-g]+(?: |$))+)"
notes = open("digits.txt") do f
    map(n -> split.(n, " "), match.(pattern, readlines(f)))
end

# 1 = 2, 4 = 4, 7 = 3, 8 = 7
println(sum(n -> count(o -> length(o) in [2, 4, 3, 7], n[2]), notes))