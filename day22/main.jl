function right!(d)
  d .= [d[2]; -d[1]]
end

function left!(d)
  d .= [-d[2]; d[1]]
end

function printdisk(I::Array{Array{Int}}, w, n)
  n % 2 == 0 && (n += 1)
  shift = div(n, 2) + 1
  M = zeros(n, n)
  for (x,y) = I
    M[y+shift,x+shift] = 1
  end
  M[w[2]+shift,w[1]+shift] += 2
  for i = n:-1:1
    for j = 1:n
      c = if M[i,j] == 0
        " . "
      elseif M[i,j] == 1
        " # "
      elseif M[i,j] == 2
        "[.]"
      else
        "[#]"
      end
      print(c)
    end
    println("")
  end
end

function printdisk(M::Matrix, w, n)
  n % 2 == 0 && (n += 1)
  shift = div(n, 2) + 1
  N = div(size(M, 1), 2)
  for i = n:-1:1
    for j = 1:n
      a = M[N+i-shift,N+j-shift]
      c = if a == 0
        "."
      elseif a == 1
        "W"
      elseif a == 2
        "#"
      else
        "F"
      end
      if [j - shift, i - shift] == w
        c = "[$c]"
      else
        c = " $c "
      end
      print(c)
    end
    println("")
  end
end

function infect(lines, iters; verbose=false)
  n = length(lines)
  I = []
  for i = 1:n
    for j = 1:n
      if lines[i][j] == '#'
        ii = i - div(n, 2) - 1
        jj = j - div(n, 2) - 1
        push!(I, [jj,-ii])
      end
    end
  end
  worm = [0; 0]
  d = [0; 1]
  bursts = 0
  verbose && println("I = $I")
  verbose && printdisk(I, worm, 9)
  for iter = 1:iters
    k = length(I)
    f = 0
    for i = 1:k
      if I[i] == worm
        f = i
        break
      end
    end
    if f == 0
      left!(d)
      verbose && println("Infecting $worm: $bursts infections")
      push!(I, worm)
      bursts += 1
    else
      right!(d)
      verbose && println("Cleaning $worm: $bursts infections")
      deleteat!(I, f)
    end
    worm += d
    verbose && println("$iter d = $d")
    verbose && printdisk(I, worm, 9)
  end
  return bursts
end

function infect2(lines, iters; verbose=false)
  n = length(lines)
  M = zeros(1000, 1000)
  #sizehint!(M.rowval, iters * 50)
  #sizehint!(M.nzval, iters * 50)
  N = div(size(M,1), 2)
  for i = 1:n
    for j = 1:n
      if lines[i][j] == '#'
        ii = N - i + div(n, 2) + 1
        jj = N + j - div(n, 2) - 1
        M[ii,jj] = 2
      end
    end
  end
  worm = [0; 0]
  d = [0; 1]
  bursts = 0
  verbose && printdisk(M, worm, 9)
  for iter = 1:iters
    i, j = N + worm[2], N + worm[1]
    t = M[i,j]
    verbose && println("$iter t = $t")
    if t == 0 # Clean
      left!(d)
      M[i,j] = 1
    elseif t == 1 # Weakened
      M[i,j] = 2
      bursts += 1
    elseif t == 2 # Infected
      right!(d)
      M[i,j] = 3
    elseif t == 3 # Flagged
      d .= -d
      M[i,j] = 0
    end
    worm += d
    verbose && println("$iter d = $d")
    verbose && printdisk(M, worm, 9)
    if iter > 3
      verbose = false
    end
  end
  return bursts
end

function main()
  for (input,b) in [
                    ("test-input",7),
                    ("test-input",70),
                    ("test-input",10_000),
                    ("input.txt",10_000)
                   ]
    s = infect(readlines(input), b, verbose=false)
    println("s = $s")
  end
  for (input,b) in [
                    ("test-input", 100),
                    ("test-input", 10000000),
                    ("input.txt",  10000000)
                   ]
    s = infect2(readlines(input), b, verbose=false)
    println("s = $s")
  end
end

main()
