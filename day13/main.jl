function movement(D, start=0, hardcore=false)
  n = length(D)
  s = 0
  for i = 1:n
    if D[i] == 0
      continue
    end
    f = 2 * (D[i] - 1)
    if (start + i - 1) % f == 0
      if hardcore
        return Inf
      end
      s += (i - 1) * D[i]
    end
  end
  return s
end

function walk(lines)
  n = parse(split(lines[end], ": ")[1]) + 1
  D = zeros(Int, n)
  for line in lines
    sline = split(line, ": ")
    i, d = parse.(sline)
    D[i+1] = d
  end

  start = 0
  while movement(D, start, true) > 0
    start += 1
  end
  return movement(D, 0), start
end

function main()
  for input in ["test-input", "input.txt"]
    lines = readlines(input)
    s = walk(lines)
    println("s = $s")
  end
end

main()
