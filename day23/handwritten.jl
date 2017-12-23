function foo()
  a = 1
  b = c = d = e = f = h = 0
  b = 93
  c = b
  if a == 1
    b *= 100
    b += 100000
    c = b
    c += 17000
  end
  while true
    f = 1
    d = 2
    while true
      e = 2
      while true
        if d * e == b
          f = 0
        elseif d * e > b
          break
        end
        e += 1
        if e == b
          break
        end
      end
      d += 1
      if d == b || f == 0
        break
      end
    end
    if f == 0
      h += 1
    end
    if b == c
      break
    end
    b += 17
  end
  return h
end

println(foo())
