#=
Challenge 6
Break repeating-key XOR

Start: 12/11/18
Finished: 12/30/18
=#

import Base64.base64decode
include("./score.jl")

function hamming_dist(s1, s2)
    s1_bits_arr = broadcast(bitstring, s1)
    s2_bits_arr = broadcast(bitstring, s2)
    s1_bits = ""
    s2_bits = ""
    for i = 1:length(s1)
        s1_bits *= s1_bits_arr[i]
        s2_bits *= s2_bits_arr[i]
    end
    dist = 0
    for (s1_b, s2_b) in zip(s1_bits, s2_bits)
        dist += (s1_b != s2_b) ? 1 : 0
    end
    return dist
end

function guess_keysize(ciphert)
    norm_hamming_dists = fill(Inf, (40))
    for size = 2:40
        block_1 = ciphert[1:size]
        block_2 = ciphert[size+1:2*size]
        block_3 = ciphert[2*size+1:3*size]
        block_4 = ciphert[3*size+1:4*size]
        norm_hamming_dists[size] = (hamming_dist(block_1, block_2) + hamming_dist(block_2, block_3) + hamming_dist(block_3, block_4))/(3 * size)
    end
    #println(norm_hamming_dists)
    guesses = Array{Int}(undef, 0)
    for i = 1:5
        push!(guesses, argmin(norm_hamming_dists))
        norm_hamming_dists[argmin(norm_hamming_dists)] = Inf
    end
    return guesses
end

function decrypt(ciphert)
    guesses = guess_keysize(ciphert)
    guesses = [2,29]
    max_score = -Inf
    likely_key = nothing
    likely_plaint = nothing
    for k in guesses
        keysize = k

        blocks = Array{Array{UInt8}}(undef, 0)
        for i = 0:(Int(floor(length(ciphert)/keysize))-1)
            push!(blocks, ciphert[i*keysize+1:(i+1)*keysize])
        end

        if mod(length(ciphert)/keysize, 1) != 0
            push!(blocks, ciphert[Int((floor(length(ciphert)/keysize)))*keysize:length(ciphert)])
        end

        key = Array{UInt8}(undef, 0)
        for j = 1:keysize
            arr_T = Array{UInt8}(undef, 0)
            for i = 1:length(blocks)-1
                push!(arr_T, blocks[i][j])
            end
            push!(key, find_key(arr_T))
        end

        repeating_key = Array{UInt8}(undef, length(ciphert))
        key_pos = 1
        for i = 1:length(repeating_key)
            repeating_key[i] = key[key_pos]
            key_pos += 1
            if key_pos > length(key)
                key_pos = 1
            end
        end

        plaint = broadcast(xor, ciphert, repeating_key)
        if score(plaint) > max_score
            max_score = score(plaint)
            likely_key = key
            likely_plaint = plaint
        end
    end
    return likely_plaint
end


function main()
    #s1 = Array{UInt8}("this is a test")
    #s2 = Array{UInt8}("wokka wokka!!!")
    #println(hamming_dist(s1, s2))
    ciphert = nothing
    open("6.txt") do file
        ciphert = read(file, String)
    end
    ciphert = base64decode(strip(ciphert))
    plaint = decrypt(ciphert)
    println(String(plaint))
end

main()
