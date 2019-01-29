#=
Challenge 10
Implement CBC mode

Start: 1/28/19
Finished: 1/28/19
=#

import Base64.base64decode
import Base64.base64encode
using PyCall

@pyimport cryptography.hazmat.primitives.ciphers as ciphers
@pyimport cryptography.hazmat.primitives.ciphers.algorithms as algorithms
@pyimport cryptography.hazmat.primitives.ciphers.modes as modes
@pyimport cryptography.hazmat.backends as backends

function CBC_encrypt(key, iv, plaint)
    cipher = ciphers.Cipher(algorithms.AES(pybytes(key)), modes.ECB(), backend=backends.default_backend())
    encryptor = cipher[:encryptor]()

    c_prev = iv
    plaint = [plaint[i:min(i+15,length(plaint))] for i in 1:16:length(plaint)]
    ciphert = Array{UInt8}(undef, 0)
    for i = 1:length(plaint)
        encrypted_block = Array{UInt8}(string(decryptor[:update](pybytes(broadcast(xor, c_prev, plaint[i])))))
        ciphert = cat(dims=1, plaint, encrypted_block)
        c_prev = encrypted_block
    end
    encryptor[:finalize]()
    return ciphert
end

function CBC_decrypt(key, iv, ciphert)
    cipher = ciphers.Cipher(algorithms.AES(pybytes(key)), modes.ECB(), backend=backends.default_backend())
    decryptor = cipher[:decryptor]()

    c_prev = iv
    ciphert = [ciphert[i:min(i+15,length(ciphert))] for i in 1:16:length(ciphert)]
    plaint = Array{UInt8}(undef, 0)
    for i = 1:length(ciphert)
        decrypted_block = Array{UInt8}(string(decryptor[:update](pybytes(ciphert[i]))))
        plaint = cat(dims=1, plaint, broadcast(xor, c_prev, decrypted_block))
        c_prev = ciphert[i]
    end
    decryptor[:finalize]()
    return plaint
end

function main()
    key = "YELLOW SUBMARINE"
    iv = fill(0x00, 16)
    ciphert = nothing
    open("10.txt") do file
        ciphert = read(file, String)
    end
    ciphert = base64decode(strip(ciphert))
    key = Array{UInt8}(key)
    plaint = CBC_decrypt(key, iv, ciphert)
    println(String(plaint))
end

main()
