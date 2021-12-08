pattern = r"((?:[a-g]+ ?)+) \| ((?:[a-g]+(?: |$))+)"
notes = open("digits.txt") do f
    map(n -> map(a -> Set.(split.(a, "")), n), map(n -> split.(n, " "), match.(pattern, readlines(f))))
end

# 1 = 2, 4 = 4, 7 = 3, 8 = 7
println(sum(n -> count(o -> length(o) in [2, 4, 3, 7], n[2]), notes))

value_sum = 0
for note in notes
    signal = note[1]
    one = filter(s -> length(s) == 2, signal)[1]
    four = filter(s -> length(s) == 4, signal)[1]
    seven = filter(s -> length(s) == 3, signal)[1]
    eight = filter(s -> length(s) == 7, signal)[1]

    twothreefive = filter(s -> length(s) == 5, signal)
    two = twothreefive[findfirst(x -> length(x) == 3, map(x -> setdiff(x, four), twothreefive))]
    e = setdiff(union(map(x -> setdiff(x, four), twothreefive)...), intersect(map(x -> setdiff(x, four), twothreefive)...))
    nine = setdiff(eight, e)
    c = intersect(one, two)
    six = setdiff(eight, c)
    five = setdiff(six, e)
    three = filter(x -> x ∉ [two, five], twothreefive)[1]
    zerosixnine = filter(s -> length(s) == 6, signal)
    zero = filter(x -> x ∉ [six, nine], zerosixnine)[1]
    digits = [zero, one, two, three, four, five, six, seven, eight, nine]

    output = note[2]
    global value_sum += parse(Int, join(map(i -> findfirst(x -> x == i, digits)-1, output)))
end

println(value_sum)
