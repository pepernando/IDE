arr = []

arr.push("ewrewrew",34)
arr.push("wqeqeq",23)
arr.push("DFSDFweq",3)
arr.push("erwrwe",6)
arr.push("erwer",33)

# arr.sort! { |a, b|  a[1] <=> b[1] }

arr.each{ |x|
    puts "#{x}"
}

puts "asd: #{arr[2]}"