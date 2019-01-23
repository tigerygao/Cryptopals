#=
Challenge 9
Implementing PKCS#7 padding

Start: 1/22/19
Finished: 1/22/19
=#

function pkcs_7_pad(to_be_padded, block_size)
    to_be_padded = Array{UInt8}(to_be_padded)
    num_blocks = div(length(to_be_padded), block_size)
    if length(to_be_padded) % block_size != 0
        num_blocks += 1
    end
    padding = UInt8(num_blocks*block_size - length(to_be_padded))
    for i = 1:num_blocks*block_size - length(to_be_padded)
        push!(to_be_padded, padding)
    end
    return to_be_padded
end

function main()
    to_be_padded = "YELLOW SUBMARINE"
    block_size = 20
    println(string(pkcs_7_pad(to_be_padded, block_size)))
end

main()
