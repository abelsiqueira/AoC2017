include("../aux.jl")

function path(x)
  lvl = 0
  while x > (2 * lvl + 1)^2
    lvl += 1
  end

  if lvl == 0
    return 0
  end
  posx, posy = lvl, -lvl
  steps = 2 * lvl + 1
  num = (2 * (lvl -1) + 1)^2 + 1
  for (sx,sy) in [(0,1), (-1,0), (0,-1), (1,0)]
    for i = 1:steps-1
      posx, posy = posx + sx, posy + sy
      if x == num
        return abs(posx) + abs(posy)
      end
      num += 1
    end
  end
end

function path2(x)
  if x == 1
    return 1
  end
  c = 1
  n = path(x)
  M = zeros(2n+3, 2n+3)
  M[n+1,n+1] = 1
  i, j = n+1, n+1
  for lvl = 1:n
    steps = 2 * lvl
    i += 1
    j -= 1
    for (sx,sy) in [(0,1), (-1,0), (0,-1), (1,0)]
      for k = 1:steps
        c += 1
        i, j = i + sx, j + sy
        M[i, j] = sum(M[i-1:i+1,j-1:j+1])
        if M[i,j] > x
          #C = M[n+1-lvl:n+1+lvl,n+1-lvl:n+1+lvl]
          #print_matrix(C)
          return M[i,j]
        end
      end
    end
  end
end

function main()
  for x in [1; 9; 12; 23; 1024; 368078]
    println("$x $(path(x))")
  end

  for x in [1; 9; 12; 23; 1024; 368078]
    println("$x $(path2(x))")
  end
end

main()
