function dance(who, lines, times=1)
  t = 1
  old = []
  push!(old, who)
  who = split(who, "")
  while t <= times
    for line in lines
      what = line[1]
      if what == 's'
        shiftsize = parse(Int, line[2:end])
        who = circshift(who, shiftsize)
      elseif what == 'x'
        i, j = parse.(Int, split(line[2:end], "/"))
        i, j = i + 1, j + 1
        @inbounds who[i], who[j] = who[j], who[i]
      elseif what == 'p'
        i, j = [findfirst(who .== x) for x in split(line[2:end], "/")]
        @inbounds who[i], who[j] = who[j], who[i]
      end
    end
    t += 1
    j = findfirst(old .== join(who))
    if j > 0
      who = old[j - 1 + (times - j + 1)%(t - j) + 1]
      break
    end
    push!(old, join(who))
  end
  return join(who)
end

function main()
  s = dance("abcde", readlines("test-input"))
  println("s = $s")
  s = dance("abcdefghijklmnop", split(readline("input.txt"),","))
  println("s = $s")
  s = dance("abcdefghijklmnop", split(readline("input.txt"),","), 1_000_000_000)
  println("s = $s")
end

main()
