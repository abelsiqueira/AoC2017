function work(lines)
  n = length(lines)
  lowest = (Inf, 0, 0)
  for (i,line) in enumerate(lines)
    sline = split(line, ", ")
    p = parse.(split(sline[1][4:end-1], ","))
    v = parse.(split(sline[2][4:end-1], ","))
    a = parse.(split(sline[3][4:end-1], ","))
    if sum(abs, a) < lowest[1]
      lowest = (sum(abs, a), i-1, sum(v .* a))
    elseif sum(abs, a) == lowest[1]
      sva = sum(v .* a)
      if sva < lowest[3]
        lowest = (sum(abs, a), i-1, sum(v .* a))
      elseif sva == lowest[3]
        error("!!!")
      end
    end
  end
  return lowest
end

type Particle
  p :: Vector
  v :: Vector
  a :: Vector
end

function move(P, t :: Int)
  return P.p +
         P.v * t +
         P.a * div(t * (t + 1), 2)
end

function crash(P, Q)
  δp =  Q.p - P.p
  δv = (Q.v - P.v) + (Q.a - P.a) / 2
  δa = (Q.a - P.a) / 2
  Δ = δv.^2 - 4 * δa .* δp
  if any(Δ .< 0)
    return -1
  end

  t = Float64[]
  for i = 1:3
    if δa[i] != 0
      τ = round((-δv[i] + sqrt(Δ[i])) / 2δa[i], 4)
      if τ >= 0
        push!(t, τ)
      end
      τ = round((-δv[i] - sqrt(Δ[i])) / 2δa[i], 4)
      if τ >= 0
        push!(t, τ)
      end
    elseif δv[i] != 0
      push!(t, round(-δp[i] / δv[i], 4))
    elseif δp[i] != 0
      return -1
    end
  end
  for tt = unique(sort(t))
    tt < 0 && continue
    tt = round(Int, tt)
    if move(P, tt) == move(Q, tt)
      return tt
    end
  end

  return -1
end

function simulate(lines)
  n = length(lines)
  P = Array{Particle}(n)
  for (i,line) in enumerate(lines)
    sline = split(line, ", ")
    p = parse.(split(sline[1][4:end-1], ","))
    v = parse.(split(sline[2][4:end-1], ","))
    a = parse.(split(sline[3][4:end-1], ","))
    P[i] = Particle(p, v, a)
  end

  C = fill(-1, n, n)
  for i = 1:n
    for j = i+1:n
      C[i,j] = crash(P[i], P[j])
    end
  end
  last = unique(sort(C[:]))
  coll = 0
  for t = last[2:end]
    I, J = findn(C .== t)
    IJ = unique(sort([I; J]))
    coll += length(IJ)
    if length(IJ) == 0
      continue
    end
    K = setdiff(1:n, IJ)
    deleteat!(P, IJ)
    C = C[K, K]
    n = length(K)
  end
  return n, P
end

function main()
  input = "test-input"
  lines = readlines(input)
  n, P = simulate(lines)
  println("n = $n")
  input = "input.txt"
  lines = readlines(input)
  s = work(lines)
  println("s = $s")
  n, P = simulate(lines)
  println("n = $n")
end

main();
