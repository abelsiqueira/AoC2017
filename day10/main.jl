function knot(n, list, times = 1, simple = true)
  I = collect(0:n-1)
  p = 1
  skip = 0
  for t = 1:times
    for len = list
      reverse!(I, 1, len)
      mv = (len + skip) % n
      I = [I[mv+1:end]; I[1:mv]]
      skip += 1
      p = (p + n - mv - 1) % n + 1
    end
  end
  if simple
    if p == n
      return I[n] * I[1]
    else
      return I[p] * I[p+1]
    end
  else
    I = [I[p:end]; I[1:p-1]]
    return join(hex.([reduce(⊻, I[16 * (i-1) + (1:16)]) for i = 1:16], 2))
  end
end

function toascii(s)
  n = length(s)
  return [Int(s[i]) for i = 1:n]
end

function main()
  x = knot(5, [3, 4, 1, 5])
  println("x = $x")
  input = readline("input.txt")
  x = knot(256, parse.(split(input, ",")))
  println("x = $x")

  for str in ["", "AoC 2017", "1,2,3", "1,2,4",
                input]
    s = toascii(str)
    append!(s, [17, 31, 73, 47, 23])
    x = knot(256, s, 64, false)
    println("$str, $x")
  end
end

main()
