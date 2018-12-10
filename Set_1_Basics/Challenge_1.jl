#=
Challenge 1
Convert hex to base64

Start: 12/10/18
Finished: 12/10/18
=#

import Base64.base64encode

function hex_to_base64(hex_string)
    byte_arr = hex2bytes(hex_string)
    base64_str = base64encode(byte_arr)
    return base64_str
end


function main()
    hex_string = "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d"
    base64_string = hex_to_base64(hex_string)
    println(base64_string)
end

main()
