include("knot.jl")

function tobin(s)
  join([bin(parse(Int, x, 16), 4) for x in s])
end

function paint!(M, i, j, c)
  n = 128
  N = [(i,j)]
  while length(N) > 0
    (i,j) = pop!(N)
    if M[i,j] == c
      continue
    end
    M[i,j] = c
    for (a,b) in [(i-1,j), (i,j-1), (i+1,j), (i,j+1)]
      if a > 0 && b > 0 && a <= n && b <= n && M[a,b] == -1
        push!(N, (a,b))
      end
    end
  end
end

function paint!(M)
  n = 128
  c = 1
  for i = 1:n
    j = findfirst(M[i,:] .== -1)
    while j != 0
      paint!(M, i, j, c)
      c += 1
      j = findfirst(M[i,:] .== -1)
    end
  end
end

function defrag(key)
  s = 0
  M = zeros(Int, 128, 128)
  for i = 0:127
    b = tobin(knot("$key-$i"))
    s += sum(parse(Int, x) for x in b)
    M[i+1, :] = parse.(Int, split(b, ""))
  end
  M[find(M .== 1)] = -1
  paint!(M)

  return s, maximum(M)
end

function main()
  for key in ["flqrgnkx", "hwlqcszp"]
    s, m = defrag(key)
    println("s = $s, m = $m")
  end
end

main()
