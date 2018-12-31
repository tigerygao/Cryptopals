which_score = "advanced" # "naive" or "advanced"

function score(text_bytes)
    if which_score == "naive"
        return naive_score(text_bytes)
    end
    if which_score == "advanced"
        return advanced_score(text_bytes)
    end
    println("Error: Invalid scoring function selected.")
    quit()
end

function advanced_score(text_bytes)
    etaoi_weight = 10
    alphanumpunc_weight = 5
    loweralpha_weight = 3
    nonalphanumpunc_penalty = -10
    #alphanumspacepunc_weight = 10

    #=
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
    etaoi_score = etaoi_weight * (sum(num_es) + sum(num_Es) + sum(num_ts) + sum(num_Ts) +
    sum(num_as) + sum(num_As) + sum(num_os) + sum(num_Os) + sum(num_is) + sum(num_Is))
    =#

    etaoi_count = (text_bytes .== 0x65) .| (text_bytes .== 0x45) .| (text_bytes .== 0x74) .|
    (text_bytes .== 0x54) .| (text_bytes .== 0x61) .| (text_bytes .== 0x41) .|
    (text_bytes .== 0x6F) .| (text_bytes .== 0x4F) .| (text_bytes .== 0x69) .|
    (text_bytes .== 0x49)
    etaoi_score = etaoi_weight * sum(etaoi_count)

    alphanumpunc_count = ((text_bytes .>= 0x30) .& (text_bytes .<= 0x39)) .|
    ((text_bytes .>= 0x41) .& (text_bytes .<= 0x5A)) .| ((text_bytes .>= 0x61) .&
    (text_bytes .<= 0x7A)) .| (text_bytes .== 0x0A) .| (text_bytes .== 0x20) .|
    (text_bytes .== 0x2E) .| (text_bytes .== 0x2C) .| (text_bytes .== 0x27) .|
    (text_bytes .== 0x22) .| (text_bytes .== 0x21) .| (text_bytes .== 0x3F)
    alphanumpunc_score = alphanumpunc_weight * sum(alphanumpunc_count)

    nonalphanumpunc_score = nonalphanumpunc_penalty * sum(alphanumpunc_count .== 0)

    loweralpha_count = (text_bytes .>= 0x61) .& (text_bytes .<= 0x7A)
    loweralpha_score = loweralpha_weight * sum(loweralpha_count)

    score = etaoi_score + alphanumpunc_score + loweralpha_score + nonalphanumpunc_score

    return score
end

function naive_score(text_bytes)
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
    score = sum(num_es) + sum(num_Es) + sum(num_ts) + sum(num_Ts) + sum(num_as) + sum(num_As) + sum(num_os) + sum(num_Os) + sum(num_is) + sum(num_Is) + sum(num_ns) + sum(num_Ns)
    return score
end

#Called in Challenge_4.jl
function decrypt(ciphert)
    ciphert_bytes = hex2bytes(ciphert)
    max_score = -Inf
    likely_key = nothing
    for i in 0:255
        test_key = UInt8(i)
        text_bytes = broadcast(xor, ciphert_bytes, test_key)
        if score(text_bytes) > max_score
            max_score = score(text_bytes)
            likely_key = test_key
        end
    end
    plaint = broadcast(xor, ciphert_bytes, likely_key)
    return plaint
end


#Called in Challenge_6.jl
function find_key(ciphert)
    max_score = -Inf
    likely_key = nothing
    for i in 0:255
        test_key = UInt8(i)
        text_bytes = broadcast(xor, ciphert, test_key)
        if score(text_bytes) > max_score
            max_score = score(text_bytes)
            likely_key = test_key
        end
    end
    return likely_key
end
