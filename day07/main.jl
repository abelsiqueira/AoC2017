include("../aux.jl")

function create_graph(lines)
  n = length(lines)
  W = zeros(n)
  D = Dict()
  A = spzeros(n, n)
  for (i,line) in enumerate(lines)
    sline = split(line)
    name = sline[1]
    D[name] = i
    D[i] = name
    W[i] = parse(sline[2][2:end-1])
  end

  for (i,line) in enumerate(lines)
    sline = split(line)
    if length(sline) > 2
      adjs = split(split(line, "-> ")[2], ", ")
      for adj in adjs
        j = D[adj]
        A[i,j] = 1
        A[j,i] = -1
      end
    end
  end

  return A, W, D
end

function find_root(A, D)
  n = size(A, 1)
  done = false
  i = 1
  while !done
    done = true
    for j = 1:n
      if A[i,j] == -1
        i = j
        done = false
        break
      end
    end
  end
  return D[i]
end

function find_weight(A, W, rt)
  n = size(A, 1)
  WT = zeros(n)
  for i = 1:n
    compute_total_weight!(WT, A, W, i)
  end

  balanced = isbalanced(A, WT, rt)
  while !balanced
    sons = find(A[rt,:] .== 1)
    if length(sons) == 0
      error("Shouldn't")
    end
    balanced = true
    for j = sons
      if !isbalanced(A, WT, j)
        rt = j
        balanced = false
        break
      end
    end
  end

  # One of the sons is the culprit
  sons = find(A[rt,:] .== 1)
  if length(sons) < 2
    error("What should I do?")
  end
  m, M = extrema(WT[sons])
  Im, IM = find(WT[sons] .== m), find(WT[sons] .== M)
  if length(Im) > length(IM)
    return W[sons[IM]] + m - M
  else
    return W[sons[Im]] - m + M
  end
end

function isbalanced(A, WT, rt)
  sons = find(A[rt,:] .== 1)
  return length(sons) == 0 || all(WT[sons] .== WT[sons[1]])
end

function compute_total_weight!(WT, A, W, rt)
  sons = find(A[rt,:] .== 1)
  if length(sons) == 0
    WT[rt] = W[rt]
  else
    w = 0.0
    for j = sons
      compute_total_weight!(WT, A, W, j)
      w += WT[j]
    end
    WT[rt] = w + W[rt]
  end
end

function main()
  for name in ["test-input", "test-input2", "input"]
    println(name)
    lines = readlines(name)
    A, W, D = create_graph(lines)
    rt = find_root(A, D)
    println("rt = $rt")
    w = find_weight(A, W, D[rt])
    println("w = $w")
  end
end

main()
