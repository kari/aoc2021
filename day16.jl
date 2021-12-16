bits = open("bits.txt") do f
    readline(f)
end

struct Packet
    version::Int
    type_id::Int
    length::Int
    sub_packets::Vector{Packet}
    value::Int
end

function parse_packet(packet, depth = 0)
    version = parse(Int, join(Int.(packet[1:3])), base = 2)
    type_id = parse(Int, join(Int.(packet[4:6])), base = 2)
    # println("$(repeat(' ', 2*depth))packet is version $(version) and type $(type_id)")
    packet_length = 6
    sub_packets = []
    if type_id == 4
        # literal value packet
        binary_value = ""
        for i in Iterators.partition(packet[7:end], 5)
            binary_value *= join(Int.(i[2:end]))
            packet_length += 5
            if i[1] == 0
                break
            end
        end
        value = parse(Int, binary_value, base = 2)
        # println("$(repeat(' ', 2*depth))packet contains value $(value) (length $(packet_length))")
    else
        # operator packet
        if packet[7] == 0 # length type id
            subpackets_length = parse(Int, join(Int.(packet[8:22])), base = 2)
            packet_length += 1 + 15 + subpackets_length
            # println("$(repeat(' ', 2*depth))packet has $(subpackets_length) bits of sub-packets (total length $(packet_length))")
            processed = 0
            while processed < subpackets_length
                # println("$(repeat(' ', 2*depth))parsing packet at range $(23+processed):$(23+subpackets_length-1)")
                push!(sub_packets, parse_packet(packet[23+processed:23+subpackets_length-1], depth+1))
                processed += sub_packets[end].length
            end
        elseif packet[7] == 1
            sub_packet_count = parse(Int, join(Int.(packet[8:18])), base = 2)
            # println("$(repeat(' ', 2*depth))packet has $(sub_packet_count) sub-packets")
            ptr = 0
            while length(sub_packets) < sub_packet_count
                # println("$(repeat(' ', 2*depth))parsing packet at range $(19+ptr)")
                push!(sub_packets, parse_packet(packet[19+ptr:end], depth +1))
                ptr += sub_packets[end].length
            end
            packet_length += ptr + 11 + 1
        else
            throw("unknown length type id $(packet[7])")
        end
        value = if type_id == 0 # sum packet
            sum(map(x -> x.value, sub_packets))
        elseif type_id == 1 # product packet
            prod(map(x -> x.value, sub_packets))
        elseif type_id == 2 # minimum packet
            minimum(map(x -> x.value, sub_packets))
        elseif type_id == 3 # maximum packet
            maximum(map(x -> x.value, sub_packets))
        elseif type_id == 5 # greater than 
            sub_packets[1].value > sub_packets[2].value ? 1 : 0
        elseif type_id == 6 # smaller than
            sub_packets[1].value < sub_packets[2].value ? 1 : 0
        elseif type_id == 7 # equal
            sub_packets[1].value == sub_packets[2].value ? 1 : 0
        else
            throw("unknown packet type $(type_id)") 
        end
    end
    # println("$(repeat(' ', 2*depth))end of packet (length $(packet_length))")
    return Packet(version, type_id, packet_length, sub_packets, value)
end

function parse_hex(h)
    binary_data = BitArray(undef, 4*length(h))
    for i in 1:length(h)
        binary_data[(i-1)*4+1:(i-1)*4+4] = parse.(Int, split(bitstring(parse(Int, h[i], base=16))[end-3:end], ""))
    end

    return binary_data    
end

function version_sum(p::Packet)::Int
    if isempty(p.sub_packets)
        return p.version
    else
        return p.version + sum(version_sum.(p.sub_packets))
    end
end

#parse_packet(parse_hex("D2FE28"))
#parse_packet(parse_hex("38006F45291200"))
#parse_packet(parse_hex("EE00D40C823060"))
#println(version_sum(parse_packet(parse_hex("8A004A801A8002F478"))))
#println(version_sum(parse_packet(parse_hex("620080001611562C8802118E34"))))
#println(version_sum(parse_packet(parse_hex("C0015000016115A2E0802F182340"))))
#println(version_sum(parse_packet(parse_hex("A0016C880162017C3686B18A3D4780"))))
println(version_sum(parse_packet(parse_hex(bits))))

# println(parse_packet(parse_hex("C200B40A82")).value)
# println(parse_packet(parse_hex("04005AC33890")).value)
# println(parse_packet(parse_hex("880086C3E88112")).value)
# println(parse_packet(parse_hex("CE00C43D881120")).value)
# println(parse_packet(parse_hex("D8005AC2A8F0")).value)
# println(parse_packet(parse_hex("F600BC2D8F")).value)
# println(parse_packet(parse_hex("9C005AC2F8F0")).value)
# println(parse_packet(parse_hex("9C0141080250320F1802104A08  ")).value)
println(parse_packet(parse_hex(bits)).value)
