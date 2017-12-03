function main()
  lines = readlines("input")
  chksum = 0
  for line in lines
    v = parse.(split(line))
    m, M = extrema(v)
    chksum += M - m
  end
  println("checksum = $chksum")

  chksum = 0
  for line in lines
    v = parse.(split(line))
    n = length(v)
    done = false
    for i = 1:n
      for j = 1:n
        i == j && continue
        d, r = divrem(v[i], v[j])
        if r == 0
          done = true
          chksum += d
          break
        end
      end
      done && break
    end
  end
  println("checksum = $chksum")
end

main()
