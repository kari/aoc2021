board_pattern = r"(((\d+)\s+){5}){5}"
numbers, boards = open("bingo.txt") do f
    numbers = parse.(Int, split(readline(f), ","))
    boards = map(m -> split.(strip.(replace.(m.match, r"\s+" => " ")), " "), eachmatch(board_pattern, join(readlines(f, keep = true))))
    boards = map(r -> transpose(reshape(parse.(Int, r), 5, 5)), boards)
    return numbers, boards
end

function find_bingo(numbers, boards)
    for i in 5:length(numbers)
        for b in boards
            for c in eachcol(b)
                if length(intersect(c, numbers[1:i])) == 5
                    println("bingo")
                    return b, i
                end
            end
            for r in eachrow(b)
                if length(intersect(r, numbers[1:i])) == 5
                    println("bingo")
                    return b, i
                end
            end
        end
    end
end

board, n = find_bingo(numbers, boards)
println(sum(setdiff(reshape(board, :, 1), numbers[1:n])) * numbers[n])