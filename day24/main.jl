using JuMP, Cbc

function findpath(X, i=1)
  n = size(X, 1)
  J = find(X[i,:] .== 1)
  P = [i]
  while length(J) > 0
    j = 0
    if length(J) == 1
      j = J[1]
    else
      Ps = Any[]
      for j = J
        Xtil = copy(X)
        Xtil[i,j] -= 1
        P2 = findpath(Xtil, j)
        push!(Ps, P2)
      end
      k = indmax(length.(Ps))
      P2 = Ps[k]
      append!(P, P2)
      m = length(P2)
      for k = 1:m
        j = P2[k]
        X[i,j] -= 1
        i = j
      end
      return P
    end
    X[i,j] -= 1
    push!(P, j)
    i = j
    J = find(X[i,:] .== 1)
  end
  return P
end

function dothing(lines)
  parts = []
  n = 1
  for line in lines
    a, b = parse.(Int, split(line, "/"))
    a, b = a + 1, b + 1
    n = max(n, a, b)
    push!(parts, (a,b))
  end
  N = length(parts)
  model = Model(solver=CbcSolver())
  @variable(model, x[1:n,1:n], Bin)
  @variable(model, s[2:n], Bin)
  for i = 1:n
    for j = 1:n
      if !((i,j) in parts || (j,i) in parts)
        @constraint(model, x[i,j] == 0)
        if i != j
          @constraint(model, x[j,i] == 0)
        end
      end
    end
  end
  for (i,j) in parts
    if i != j
      @constraint(model, x[i,j] + x[j,i] <= 1)
    end
  end
  @objective(model, Max,
             sum(x[i,j] * (i + j - 2) for i = 1:n, j = 1:n))
  @constraint(model, 1 + sum(x[j,1] for j = 1:n)
              == sum(x[1,j] for j = 1:n))
  for i = 2:n
    @constraint(model, sum(x[j,i] for j = 1:n)
                >= sum(x[i,j] for j = 1:n))
  end
  HAND = [43]
  if n >= 43
    for h = HAND
      @constraint(model, sum(x[j,h] for j = 1:n if j != h) >= 1)
    end
  end
  #@constraint(model, sum(s) == 1)
  done = false
  X = 0
  L = []
  while !done
    done = true
    println(solve(model))
    X = getvalue(x)
    # Search for loop
    #=
    for i = 1:n
      print("$i -> ")
      for j = find(X[i,:] .== 1)
        print("$j ")
      end
      println("")
      print("$i <- ")
      for j = find(X[:,i] .== 1)
        print("$j ")
      end
      println("")
    end
    =#
    println("f = $(getobjectivevalue(model))")
    P = findpath(X)
    println("P = $P")
    #println("#P = $(length(P))")
    #println("∑P = $(sum(P))")

    # Testing path
    nP = length(P)
    used = fill(false, N)
    for k = 1:nP-1
      i, j = P[k], P[k+1]
      q = 0
      for p = 1:N
        if parts[p] in [(i,j), (j,i)]
          q = p
          if used[q]
            error("Double used part: $i,$j")
          end
          break
        end
      end
      used[q] = true
    end

    I, J = findn(X .== 1)
    for (i,j) in zip(I, J)
      println("$i->$j")
    end

    model = Model(solver=CbcSolver())
    @variable(model, x[1:n,1:n], Bin)
    @variable(model, s[2:n], Bin)
    for i = 1:n
      for j = 1:n
        if !((i,j) in parts || (j,i) in parts)
          @constraint(model, x[i,j] == 0)
          if i != j
            @constraint(model, x[j,i] == 0)
          end
        end
      end
    end
    for (i,j) in parts
      if i != j
        @constraint(model, x[i,j] + x[j,i] <= 1)
      end
    end
    @objective(model, Max,
               sum(x[i,j] * (i + j - 2) for i = 1:n, j = 1:n))
    @constraint(model, 1 + sum(x[j,1] for j = 1:n)
                == sum(x[1,j] for j = 1:n))
    for i = 2:n
      @constraint(model, sum(x[j,i] for j = 1:n)
                  >= sum(x[i,j] for j = 1:n))
    end
    #@constraint(model, sum(s) == 1)
    I, J = findn(X .== 1)
    println("L = $L")
    for (i,j) in L
      @constraint(model, x[i,j] == 0)
    end
    I, J = findn(X .== 1)
    for (i,j) in zip(I, J)
      if !(i ∈ P || j ∈ P)
        push!(L, (i,j))
        println("Loop: $i/$j")
        @constraint(model, x[i,j] == 0)
        done = false
      end
    end
    if n >= 43
      for h = HAND
        @constraint(model, sum(x[j,h] for j = 1:n if j != h) >= 1)
      end
    end
  end
  return X
end

function dootherthing(lines)
  parts = []
  n = 1
  for line in lines
    a, b = parse.(Int, split(line, "/"))
    a, b = a + 1, b + 1
    n = max(n, a, b)
    push!(parts, (a,b))
  end
  N = length(parts)
  model = Model(solver=CbcSolver())
  @variable(model, x[1:n,1:n], Bin)
  for i = 1:n
    for j = 1:n
      if !((i,j) in parts || (j,i) in parts)
        @constraint(model, x[i,j] == 0)
        if i != j
          @constraint(model, x[j,i] == 0)
        end
      end
    end
  end
  for (i,j) in parts
    if i != j
      @constraint(model, x[i,j] + x[j,i] <= 1)
    end
  end
  @objective(model, Max, sum(x[i,j] * (1 + (i + j - 2) / 100) for i = 1:n, j = 1:n))
  @constraint(model, 1 + sum(x[j,1] for j = 1:n)
              == sum(x[1,j] for j = 1:n))
  for i = 2:n
    @constraint(model, sum(x[j,i] for j = 1:n)
                >= sum(x[i,j] for j = 1:n))
  end
  HAND = [6]
  if length(HAND) > 0 && n >= maximum(HAND)
    for h = HAND
      @constraint(model, sum(x[j,h] for j = 1:n if j != h) >= 1)
    end
  end
  #@constraint(model, sum(s) == 1)
  done = false
  X = 0
  L = []
  while !done
    done = true
    println(solve(model))
    X = getvalue(x)
    # Search for loop
    #=
    for i = 1:n
      print("$i -> ")
      for j = find(X[i,:] .== 1)
        print("$j ")
      end
      println("")
      print("$i <- ")
      for j = find(X[:,i] .== 1)
        print("$j ")
      end
      println("")
    end
    =#
    println("f = $(getobjectivevalue(model))")
    P = findpath(X)
    println("P = $P")
    #println("#P = $(length(P))")
    #println("∑P = $(sum(P))")

    # Testing path
    nP = length(P)
    used = fill(false, N)
    str = 0
    for k = 1:nP-1
      i, j = P[k], P[k+1]
      str += i + j - 2
      q = 0
      for p = 1:N
        if parts[p] in [(i,j), (j,i)]
          q = p
          if used[q]
            error("Double used part: $i,$j")
          end
          break
        end
      end
      used[q] = true
    end
    println("str = $str")

    I, J = findn(X .== 1)
    for (i,j) in zip(I, J)
      println("$i->$j")
    end

    model = Model(solver=CbcSolver())
    @variable(model, x[1:n,1:n], Bin)
    @variable(model, s[2:n], Bin)
    for i = 1:n
      for j = 1:n
        if !((i,j) in parts || (j,i) in parts)
          @constraint(model, x[i,j] == 0)
          if i != j
            @constraint(model, x[j,i] == 0)
          end
        end
      end
    end
    for (i,j) in parts
      if i != j
        @constraint(model, x[i,j] + x[j,i] <= 1)
      end
    end
    @objective(model, Max, sum(x[i,j] * (1 + (i + j - 2) / 100) for i = 1:n, j = 1:n))
    @constraint(model, 1 + sum(x[j,1] for j = 1:n)
                == sum(x[1,j] for j = 1:n))
    for i = 2:n
      @constraint(model, sum(x[j,i] for j = 1:n)
                  >= sum(x[i,j] for j = 1:n))
    end
    #@constraint(model, sum(s) == 1)
    I, J = findn(X .== 1)
    println("L = $L")
    for (i,j) in L
      @constraint(model, x[i,j] == 0)
    end
    I, J = findn(X .== 1)
    for (i,j) in zip(I, J)
      if !(i ∈ P || j ∈ P)
        push!(L, (i,j))
        println("Loop: $i/$j")
        @constraint(model, x[i,j] == 0)
        done = false
      end
    end
    if length(HAND) > 0 && n >= maximum(HAND)
      for h = HAND
        @constraint(model, sum(x[j,h] for j = 1:n if j != h) >= 1)
      end
    end
  end
  return X
end

function main()
  X = 0
  for input in ["test-input", "test-input2", "test-input3", "input.txt"]
    println("## input = $input")
    dothing(readlines(input))
    println("### Longest")
    dootherthing(readlines(input))
  end
end

main()
