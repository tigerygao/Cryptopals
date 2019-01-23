#=
Challenge 8
Detect AES in ECB mode

Start: 1/22/18
Finished: 1/22/18
=#

function score(byte_arr)
    #Motivating idea behind this scoring method is that hopefully in the plaintext are repeated blocks that would be encrypted into the same block in AES-ECB mode
    byte_arr = [byte_arr[i:min(i+15,length(byte_arr))] for i in 1:16:length(byte_arr)] #splits byte_arr array into a 2-D array of its constituent blocks
    repeated_count = 0
    for i = 1:length(byte_arr)-1
        for j = i+1:length(byte_arr)
            if byte_arr[i] == byte_arr[j]
                repeated_count += 1
            end
        end
    end
    return repeated_count
end

function find_aes_ecb(byte_arrs)
    max_score = -1
    likely_line = nothing
    for byte_arr in byte_arrs
        if score(byte_arr) > max_score
            likely_line = byte_arr
            max_score = score(byte_arr)
        end
    end
    #println(max_score)
    return likely_line
end

function main()
    byte_arrs = Array{Array{UInt8}}(undef, 0)
    open("8.txt") do file
        for ln in eachline(file)
            push!(byte_arrs, hex2bytes(ln))
        end
    end
    encrypted_line = find_aes_ecb(byte_arrs)
    println(string(encrypted_line))
end

main()
