#=
Challenge 7
AES in ECB mode

Start: 1/13/19
Finished: 1/16/19
=#

import Base64.base64decode
import Base64.base64encode

#=
function aes_decrypt(key, ciphertblock)
    open("cipherblock", "w") do file
        write(file, ciphertblock)
    end
    open("key", "w") do file
        write(file, string(key,"\n",key))
    end
    plaintblock = read(pipeline(`openssl enc -aes-128-ecb -in cipherblock`, stdin="key"), String)
    plaintblock = base64encode(hex2bytes(plaintblock))
    run(`rm cipherblock`)
    run(`rm key`)
    return plaintblock
end

function decrypt(key, ciphert)
    while size(ciphert, 1) % 16 != 0
        push!(ciphert, 0x00)
    end
    ciphert = [ciphert[i:min(i+15,length(ciphert))] for i in 1:16:length(ciphert)]
    plaint = Array{UInt8}(undef, 0)
    for i = 1:size(ciphert, 1)
        append!(plaint, aes_decrypt(key, ciphert[i]))
    end
    return plaint
end
=#

using PyCall

@pyimport cryptography.hazmat.primitives.ciphers as ciphers
@pyimport cryptography.hazmat.primitives.ciphers.algorithms as algorithms
@pyimport cryptography.hazmat.primitives.ciphers.modes as modes
@pyimport cryptography.hazmat.backends as backends

function decrypt(key, ciphert)
    cipher = ciphers.Cipher(algorithms.AES(pybytes(key)), modes.ECB(), backend=backends.default_backend())
    decryptor = cipher[:decryptor]()
    plaint = string(decryptor[:update](pybytes(ciphert)), decryptor[:finalize]())
    return Array{UInt8}(plaint)
end

function main()
    key = "YELLOW SUBMARINE"
    ciphert = nothing
    open("7.txt") do file
        ciphert = read(file, String)
    end
    ciphert = base64decode(strip(ciphert))
    key = Array{UInt8}(key)
    plaint = decrypt(key, ciphert)
    println(String(plaint))
end

main()
