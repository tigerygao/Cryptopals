#=
Challenge 3
Single-byte XOR cipher
Find the single character key the ciphertext has been XOR'd against and decrypt the message.

Start: 12/10/18
Finished: 12/10/18
=#

#Scoring I used is just the number of times the characters "e", "E", "t", "T", "a", "A", "o", "O", "i", "I", "n" or "N" appear in the decryption of the ciphertext under each prospective character key. Basically, seeing how many times the 6 most frequent letter of the English alphabet appears in the prospective plaintext.
#SHOULD PROBABLY COME BACK TO THIS AND DESIGN AND IMPLEMENT A MORE NOVEL/EFFICIENT SCORING METHOD!!!
function score(text_bytes)
    num_es = (text_bytes .== 0x65)
    num_Es = (text_bytes .== 0x45)
    num_ts = (text_bytes .== 0x74)
    num_Ts = (text_bytes .== 0x54)
    num_as = (text_bytes .== 0x61)
    num_As = (text_bytes .== 0x41)
    num_os = (text_bytes .== 0x6F)
    num_Os = (text_bytes .== 0x4F)
    num_is = (text_bytes .== 0x69)
    num_Is = (text_bytes .== 0x49)
    num_ns = (text_bytes .== 0x6E)
    num_Ns = (text_bytes .== 0x4E)
    total_es = sum(num_es) + sum(num_Es) + sum(num_ts) + sum(num_Ts) + sum(num_as) + sum(num_As) + sum(num_os) + sum(num_Os) + sum(num_is) + sum(num_Is) + sum(num_ns) + sum(num_Ns)
    return total_es
end

function decrypt(ciphert)
    ciphert_bytes = hex2bytes(ciphert)
    max_es = -1
    likely_key = nothing
    for i in 0:255
        test_key = UInt8(i)
        text_bytes = broadcast(xor, ciphert_bytes, test_key)
        if score(text_bytes) > max_es
            max_es = score(text_bytes)
            likely_key = test_key
        end
    end
    plaint = broadcast(xor, ciphert_bytes, likely_key)
    return plaint
end


function main()
    ciphertxt = "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736"
    plaintxt = decrypt(ciphertxt)
    println(String(plaintxt))
end

main()
