diagnostics = open("diagnostics.txt") do f
    hcat(map(row -> parse.(Int, split(row, "")), readlines(f))...)
end

gamma_rate = parse(Int, join(round.(Int, sum(diagnostics, dims = 2)/size(diagnostics, 2))), base = 2)
epsilon_rate = ~gamma_rate & ((1 << size(diagnostics, 1)) - 1)

println(gamma_rate*epsilon_rate)

