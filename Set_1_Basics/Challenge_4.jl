#=
Challenge 4
Detect single-character XOR
One of the 60-character strings in this file has been encrypted by single-character XOR. Find it.

Start: 12/10/18
Finished: 12/11/18
=#

include("./score.jl")

function find_xor(str_arr)
    max_score = -1
    likely_string = nothing
    for s in str_arr
        likely_decrypt = decrypt(s)
        if score(likely_decrypt) > max_score
            max_score = score(likely_decrypt)
            likely_string = s
        end
    end
    return likely_string
end


function main()
    string_array = Array{String}(undef, 0)
    open("4.txt") do file
        for ln in eachline(file)
            push!(string_array, ln)
        end
    end
    XORd_string = find_xor(string_array)
    println(XORd_string)
end

main()
