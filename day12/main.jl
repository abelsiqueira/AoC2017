function create_graph(lines)
  n = length(lines)
  A = spzeros(n, n)
  for line in lines
    sline = split(line)
    i = parse(sline[1]) + 1
    neigh = parse.(split(join(sline[3:end]),","))
    for j = neigh
      A[i,j+1] = 1
    end
  end
  return A
end

function process(lines)
  A = create_graph(lines)
  n = size(A, 1)
  V = zeros(n)
  i = 1
  g = 0
  while any(V .== 0)
    g += 1
    V[i] = g
    N = find(A[i,:] .== 1)
    while length(N) > 0
      i = pop!(N)
      if V[i] == g
        continue
      end
      V[i] = g
      append!(N, [j for j = 1:n if V[j] == 0 && A[i,j] == 1])
    end
    if any(V .== 0)
      i = findfirst(V .== 0)
    end
  end
  return [count(V .== i) for i = 1:g]
end

function main()
  for input in ["test-input", "input.txt"]
    lines = readlines(input)
    g = process(lines)
    println("g1 = $(g[1]), #g = $(length(g))")
  end
end

main()
