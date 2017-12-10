function balance(mem)
  n = length(mem)
  older = []
  c = 0
  while !(mem in older)
    push!(older, copy(mem))
    i = indmax(mem)
    x = mem[i]
    mem[i] = 0
    while x > n
      mem .+= 1
      x -= n
    end
    I = ( (i+1:i+x) - 1) .% n + 1
    mem[I] += 1
    c += 1
  end
  i = find(isequal(x, mem) for x in older)
  return c, c - i + 1
end

function main()
  c = balance([0; 2; 7; 0])
  println("c = $c")
  input = parse.(split(readline("input")))
  c = balance(input)
  println("c = $c")
end

main()
