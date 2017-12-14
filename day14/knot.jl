function knot(s, n=256, times = 64, simple = false)
  list = toascii(s)
  append!(list, [17, 31, 73, 47, 23])
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
