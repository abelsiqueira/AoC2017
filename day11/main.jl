#=
The steps are either (0,±1) or (±√3/2,±1/2)
=#
function move(dir, x, y)
  signs = Dict("n"  => [sin(0*pi/3); cos(0*pi/3)],
               "ne" => [sin(1*pi/3); cos(1*pi/3)],
               "se" => [sin(2*pi/3); cos(2*pi/3)],
               "s"  => [sin(3*pi/3); cos(3*pi/3)],
               "sw" => [sin(4*pi/3); cos(4*pi/3)],
               "nw" => [sin(5*pi/3); cos(5*pi/3)])
  dx, dy = signs[dir]
  return round(x + dx, 8), round(y + dy, 8)
end

function calc_dist(x, y)
  # For the distance, symmetry applies
  x = abs(x)
  y = abs(y)
  d = 0
  while x > 0
    x, y = move("sw", x, y)
    y = abs(y)
    d += 1
  end
  # x = 0
  # Just move south
  d += round(Int, y)
  return d
end

function walk(path)
  path = split(path, ",")
  sq2 = sqrt(3) / 2

  n = length(path)
  md = 0
  x, y = 0.0, 0.0
  for i = 1:n
    x, y = move(path[i], x, y)
    md = max(md, calc_dist(x, y))
  end

  return calc_dist(x, y), md
end

function main()
  for path in ["ne,ne,ne",
               "ne,ne,sw,sw",
               "ne,ne,s,s",
               "se,sw,se,sw,sw"]
    loc = walk(path)
    println("loc = $loc")
  end

  input = readline("input.txt")
  loc = walk(input)
  println("loc = $loc")
end

main()
