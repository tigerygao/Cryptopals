#=
Challenge 2
Fixed XOR
Write a function that takes two equal-length buffers and produces their XOR combination.

Start: 12/10/18
Finished: 12/10/18
=#

function XOR(bufA, bufB)
    a_byte_arr = hex2bytes(bufA)
    b_byte_arr = hex2bytes(bufB)
    aXORb = Array{UInt8}(undef, length(a_byte_arr))
    '''
    for i = 1:length(a_byte_arr)
        aXORb[i] = xor(a_byte_arr[i], b_byte_arr[i])
    end
    '''
    aXORb = broadcast(xor, a_byte_arr, b_byte_arr)
    return aXORb
end


function main()
    bufA = "1c0111001f010100061a024b53535009181c"
    bufB = "686974207468652062756c6c277320657965"
    aXORb = bytes2hex(XOR(bufA, bufB))
    println(aXORb)
end

main()
