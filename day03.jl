diagnostics = open("diagnostics.txt") do f
    hcat(map(row -> parse.(Int, split(row, "")), readlines(f))...)
end

gamma_rate = parse(Int, join(round.(Int, sum(diagnostics, dims = 2)/size(diagnostics, 2))), base = 2)
epsilon_rate = ~gamma_rate & ((1 << size(diagnostics, 1)) - 1)

println(gamma_rate*epsilon_rate)

oxygen = copy(diagnostics)
for i in 1:size(oxygen, 2)
    if sum(oxygen[i,:])/size(oxygen, 2) >= 0.5
        global oxygen = oxygen[:,oxygen[i, :] .== 1]
    else
        global oxygen = oxygen[:,oxygen[i, :] .== 0]
    end
    if size(oxygen, 2) == 1
        break
    end
end
oxygen_generator_rating = parse(Int, join(oxygen), base = 2)

co2 = copy(diagnostics)
for i in 1:size(co2, 2)
    if sum(co2[i,:])/size(co2, 2) >= 0.5
        global co2 = co2[:,co2[i, :] .== 0]
    else
        global co2 = co2[:,co2[i, :] .== 1]
    end
    if size(co2, 2) == 1
        break
    end
end
co2_scrubber_rating = parse(Int, join(co2), base = 2)

println(oxygen_generator_rating*co2_scrubber_rating)