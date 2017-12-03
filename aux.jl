function print_matrix(C)
  m, n = size(C)
  for i = 1:m
    for j = 1:n
      print(C[i,j])
      print(" ")
    end
    println("")
  end
end
