type State
  write :: Array{Int}
  move :: Array{Int}
  change :: Array{Int}
end

function turing(states, steps)
  tape = zeros(Int, steps)
  N = div(length(tape), 2)
  pos = N
  state = 1
  for step = 1:steps
    v = tape[pos]
    S = states[state]
    write, move, state = S.write[v+1], S.move[v+1], S.change[v+1]
    tape[pos] = write
    pos += move
  end
  return sum(tape)
end

function main()
  for (states,steps) in Any[
                            ([State([1;0],[1;-1],[2;2]),
                              State([1;1],[-1;1],[1;1])], 6),
                            ([State([1;1],[1;-1],[2;5]),
                              State([1;1],[1;1],[3;6]),
                              State([1;0],[-1;1],[4;2]),
                              State([1;0],[1;-1],[5;3]),
                              State([1;0],[-1;1],[1;4]),
                              State([1;1],[1;1],[1;3])],12523873)
                           ]
    s = turing(states, steps)
    println("s = $s")
  end
end

main()
