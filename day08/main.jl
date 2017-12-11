function runcode(lines)
  regs = Set()
  for line in lines
    sline = split(line)
    push!(regs, sline[1])
    push!(regs, sline[5])
  end
  for reg in regs
    eval(parse("$reg = 0"))
  end
  #regs = Dict(r => 0 for r in regs)

  M = 0

  for line in lines
    sline = split(line)
    cond = join(sline[5:end], " ")
    if eval(parse(cond))
      sline[2] = if sline[2] == "inc"
        "+="
      elseif sline[2] == "dec"
        "-="
      end
      inst = join(sline[1:3])
      eval(parse(inst))
    end
    M = max(M, maximum(eval(parse(r)) for r in regs))
  end

  m = maximum(eval(parse(r)) for r in regs)

  return m, M
end

function main()
  for name in ["test-input", "input"]
    println(name)
    lines = readlines(name)
    r = runcode(lines)
    println(r)
  end
end

main()
