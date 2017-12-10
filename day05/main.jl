function steps(list)
  i = 1
  n = length(list)
  c = 0
  while 1 ≤ i ≤ n
    j = i + list[i]
    list[i] += 1
    i = j
    c += 1
  end
  return c
end

function steps2(list)
  i = 1
  n = length(list)
  c = 0
  while 1 ≤ i ≤ n
    j = i + list[i]
    if list[i] >= 3
      list[i] -= 1
    else
      list[i] += 1
    end
    i = j
    c += 1
  end
  return c
end

function main()
  x = steps([0; 3; 0; 1; -3])
  println("x = $x")

  list = parse.(readlines("input"))
  x = steps(list)
  println("x = $x")

  x = steps2([0; 3; 0; 1; -3])
  println("x = $x")

  list = parse.(readlines("input"))
  x = steps2(list)
  println("x = $x")
end

main()
