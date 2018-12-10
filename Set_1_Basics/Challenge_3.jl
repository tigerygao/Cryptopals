#=
Challenge 3
Single-byte XOR cipher
Find the single character key the ciphertext has been XOR'd against and decrypt the message.

Start: 12/10/18
Finished:
=#

function decrypt(ciphert)
    ciphert_bytes = hex2bytes(ciphert)

    return plaint
end

function main()
    ciphertxt = "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736"
    plaintxt = decrypt(ciphertxt)
    print(plaintxt)
end

main()
