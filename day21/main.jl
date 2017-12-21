function simulate(D, k)
  P = [0 1 0;
       0 0 1;
       1 1 1]
  n = size(P, 1)
  for iter = 1:k
    if n % 2 == 0
      N = div(n, 2)
      Pnew = zeros(Int, 3N, 3N)
      n = 3N
      for i = 1:N
        for j = 1:N
          Pnew[(1:3) + 3*(i-1), (1:3) + 3*(j-1)] = D[P[(1:2) + 2*(i-1), (1:2) + 2*(j-1)]]
        end
      end
    elseif n % 3 == 0
      N = div(n, 3)
      Pnew = zeros(Int, 4N, 4N)
      n = 4N
      for i = 1:N
        for j = 1:N
          Pnew[(1:4) + 4*(i-1), (1:4) + 4*(j-1)] = D[P[(1:3) + 3*(i-1), (1:3) + 3*(j-1)]]
        end
      end
    else
      error("!")
    end
    P = Pnew
  end
  return sum(P)
end

function art(lines, k)
  D = Dict()
  for line in lines
    s = split.(split(line, " => "), "/")
    n = length(s[1])
    A = [s[1][i][j] == '.' ? 0 : 1 for i = 1:n, j = 1:n]
    n = length(s[2])
    B = [s[2][i][j] == '.' ? 0 : 1 for i = 1:n, j = 1:n]

    D[A] = B
    D[flipdim(A, 1)] = B
    D[flipdim(A, 2)] = B
    for r = 1:3
      C = rotr90(A, r)
      D[C] = B
      D[flipdim(C, 1)] = B
      D[flipdim(C, 2)] = B
    end
  end

  return simulate(D, k)
end

function main()
  for (input,k) in [("test-input",2),
                    ("input.txt",5),
                    ("input.txt",18)]
    s = art(readlines(input), k)
    println("s = $s")
  end
end

main()
