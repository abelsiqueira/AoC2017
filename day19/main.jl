function translate(lines)
  m = length(lines)
  n = length(lines[1])
  return [lines[i][j] in ['|', '-', '+'] ? " " :
          (lines[i][j] == ' ' ? "#" : string(lines[i][j]))
          for i = 1:m, j = 1:n]
end

wall(x) = (x == "#")

function dir_trans(to)
  dx, dy = if to == :down
    0, 1
  elseif to == :up
    0, -1
  elseif to == :left
    -1, 0
  elseif to == :right
    1, 0
  end
  return dx, dy
end

function cango(to, M, i, j)
  m, n = size(M)
  dx, dy = dir_trans(to)
  return (1 ≤ i + dy ≤ m) && (1 ≤ j + dx ≤ n) && !wall(M[i + dy, j + dx])
end

function maze(lines)
  M = translate(lines)
  m, n = size(M)
  #=
  for i = 1:m
    for j = 1:n
      print(M[i,j])
    end
    println("")
  end
  =#
  i, j = 1, 0
  for k = 1:n
    if !wall(M[1,k])
      j = k
      break
    end
  end
  @assert j > 0
  going = :down
  msg = ""
  alive = true
  steps = 1
  while alive
    #println("$i,$j $going $msg")
    while cango(going, M, i, j)
      dx, dy = dir_trans(going)
      i, j = i + dy, j + dx
      msg *= strip(M[i,j])
      steps += 1
    end
    options = going in [:down, :up] ? [:left, :right] : [:down, :up]
    alive = false
    for dir in options
      if cango(dir, M, i, j)
        going = dir
        alive = true
        break
      end
    end
  end
  return msg, steps
end

function main()
  for input in ["test-input", "input.txt"]
    s = maze(readlines(input))
    println("s = $s")
  end
end

main()
