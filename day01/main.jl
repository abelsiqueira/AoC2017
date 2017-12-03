function foo()
  str = readline("input")
  n = length(str)
  s = 0
  for i = 1:n
    if str[i] == str[i%n+1]
      s += parse("$(str[i])")
    end
  end
  println("s = $s")

  s = 0
  for i = 1:n
    if str[i] == str[(i+div(n,2)-1)%n + 1]
      s += parse("$(str[i])")
    end
  end
  println("s = $s")
end

foo()
