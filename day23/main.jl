function copro(lines)
  regs = Set()
  n = length(lines)
  for i = 1:n
    sline = split(lines[i])
    inst = sline[1]
    a = sline[2]
    b = length(sline) == 3 ? sline[3] : "0"
    if inst == "set"
      lines[i] = "$a = $b"
    elseif inst == "add"
      lines[i] = "$a += $b"
    elseif inst == "sub"
      lines[i] = "$a -= $b"
    elseif inst == "mul"
      lines[i] = "$a *= $b"
    elseif inst == "jnz"
      lines[i] = "if $a != 0 counter += $b - 1 end"
    end
  end
  for reg in ["a", "b", "c", "d", "e", "f", "g", "h"]
    eval(parse("$reg = 0"))
  end

  eval(parse("n = $n"))
  eval(parse("counter = 1"))
  cmul = 0
  while eval(parse("1 ≤ counter ≤ n"))
    contains(lines[counter], "*") && (cmul += 1)
    eval(parse(lines[counter]))
    eval(parse("counter += 1"))
  end
  return cmul
end

function main()
  for input in ["input.txt"]
    s = copro(readlines(input))
    println("s = $s")
  end
  # Very bad implementation. Gave up on trying to optimize this and
  # interpret the loops. Handwritten and optimize code on handwritten.jl
end

main()
