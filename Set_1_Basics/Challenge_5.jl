#=
Challenge 5
Implement repeating-key XOR

Start: 12/11/18
Finished: 12/11/18
=#

function repeating_key_XOR(plaint, key)
    plaint = Array{UInt8}(plaint)
    key = Array{UInt8}(key)
    repeating_key = Array{UInt8}(undef, length(plaint))
    key_pos = 1
    for i = 1:length(repeating_key)
        repeating_key[i] = key[key_pos]
        key_pos += 1
        if key_pos > length(key)
            key_pos = 1
        end
    end
    ciphert = broadcast(xor, plaint, repeating_key)
    return ciphert
end


function main()
    plaint = "Burning 'em, if you ain't quick and nimble\nI go crazy when I hear a cymbal"
    key = "ICE"
    ciphert = repeating_key_XOR(plaint, key)
    println(bytes2hex(ciphert))
end

main()
