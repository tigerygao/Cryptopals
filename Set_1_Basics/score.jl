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
