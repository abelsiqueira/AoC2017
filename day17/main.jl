function spin(x, N = 2017)
  S = Int[0]
  sizehint!(S, N)
  p = 1
  for n = 1:N
    p = (p + x - 1) % n + 1
    insert!(S, p + 1, n)
    p += 1
  end
  i = findfirst(S .== 0)
  return S[p + 1], S[i + 1]
end

function spin2(x, N = 10)
  p = 1
  dp = 0
  for n = 1:N
    p = (p + x - 1) % n + 1
    if p == 1
      dp = n
    end
    p += 1
  end
  return dp
end

function main()
  for x in [3, 359]
    s = spin(x)
    println("s = $s")
  end

  s = spin2(3, 10)
  println("s = $s")

  s = spin2(359, 50000000)
  println("s = $s")
end

main()
