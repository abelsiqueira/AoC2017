function pass_valid(x)
  s = split(x)
  return length(unique(s)) == length(s)
end

function pass_valid2(x)
  s = sort.(split.(split(x), ""))
  return length(unique(s)) == length(s)
end

function main()
  lines = readlines("input")
  c = sum(pass_valid.(lines))
  println("c = $c")
  c = sum(pass_valid2.(lines))
  println("c = $c")
end

main()
