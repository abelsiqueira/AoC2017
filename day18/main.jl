function duet(lines)
  regs = Set()
  n = length(lines)
  for i = 1:n
    sline = split(lines[i])
    inst = sline[1]
    a = sline[2]
    b = length(sline) == 3 ? sline[3] : "0"
    isa(parse(a), Int) || push!(regs, a)
    isa(parse(b), Int) || push!(regs, b)
    if inst == "set"
      lines[i] = "$a = $b"
    elseif inst == "add"
      lines[i] = "$a += $b"
    elseif inst == "mul"
      lines[i] = "$a *= $b"
    elseif inst == "mod"
      lines[i] = "$a %= $b"
    elseif inst == "rcv"
      lines[i] = "if $a != 0 $a = last_$a; last = last_$a end"
    elseif inst == "jgz"
      lines[i] = "if $a > 0 counter += $b - 1 end"
    elseif inst == "snd"
      lines[i] = "last_$a = $a"
    end
  end
  for reg in regs
    eval(parse("$reg = 0"))
    eval(parse("last_$reg = 0"))
  end

  eval(parse("n = $n"))
  eval(parse("counter = 1"))
  while eval(parse("1 ≤ counter ≤ n"))
    eval(parse(lines[counter]))

    if contains(lines[counter], " = last") && eval(parse("last")) != 0
      return eval(parse("last"))
    end
    eval(parse("counter += 1"))
  end
end

function duet2(lines)
  regs = Set()
  n = length(lines)
  for i = 1:n
    sline = split(lines[i])
    inst = sline[1]
    a = sline[2]
    b = length(sline) == 3 ? sline[3] : "0"
    if !isa(parse(a), Int)
      push!(regs, a)
      a = "$a[id]"
    end
    if !isa(parse(b), Int)
      push!(regs, b)
      b = "$b[id]"
    end
    if inst == "set"
      lines[i] = "$a = $b"
    elseif inst == "add"
      lines[i] = "$a += $b"
    elseif inst == "mul"
      lines[i] = "$a *= $b"
    elseif inst == "mod"
      lines[i] = "$a %= $b"
    elseif inst == "rcv"
      lines[i] = "
if length(sent[3-id]) > 0
  $a = shift!(sent[3-id])
  blocked[id] = false
else
  blocked[id] = true
  counter[id] -= 1
end"
    elseif inst == "jgz"
      lines[i] = "if $a > 0 counter[id] += $b - 1 end"
    elseif inst == "snd"
      lines[i] = "push!(sent[id], $a); nsent[id] += 1"
    end
  end
  for reg in regs
    eval(parse("$reg = [0; 0]"))
  end
  eval(parse("sent = Any[[], []]"))
  eval(parse("nsent = [0, 0]"))
  eval(parse("counter = [1; 1]"))
  eval(parse("blocked = [false; false]"))
  eval(parse("p = [0; 1]"))

  eval(parse("n = $n"))
  while eval(parse("!all(blocked)"))
    for id = 1:2
      eval(parse("id = $id"))
      c = counter[id]
      if 1 ≤ c ≤ n
        #println(lines[c])
        eval(parse(lines[c]))
      end
    end
    if all(counter .> n)
      break
    end
    #println("a = $a")
    #println("b = $b")
    #println("counter = $counter")
    #println("i = $i")
    #println("sent = $sent")
    eval(parse("counter += 1"))
  end
  return nsent
end

function main()
  for input in ["test-input", "input.txt"]
    s = duet(readlines(input))
    println("s = $s")
  end

  for input in ["test-input2", "input.txt"]
    s = duet2(readlines(input))
    println("s = $s")
  end
end

main()
