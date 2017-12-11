function eval_group(group)
  n = length(group)
  sons = []
  count = 0
  s = 2
  i = 2
  ign = false
  garb = 0
  while i <= n
    if !ign && group[i] == '{'
      count += 1
      if count == 1
        s = i
      end
    elseif !ign && group[i] == '}'
      count -= 1
      if count == 0
        push!(sons, group[s:i])
      end
    elseif ign && group[i] == '!'
      i += 2
      continue # Avoid the garb
    elseif !ign && group[i] == '<'
      ign = true
      i += 1
      continue # Avoid the garb
    elseif group[i] == '>'
      ign = false
    end
    if ign && count == 0
      garb += 1
    end
    i += 1
  end
  if length(sons) == 0
    return [1], garb
  end
  scores = [1,]
  for son in sons
    score, g = eval_group(son)
    append!(scores, score+1)
    garb += g
  end
  return scores, garb
end

function main()
  for group in ["{}", "{{{}}}", "{{},{}}", "{{{},{},{{}}}}",
                "{<{},{},{{}}>}", "{<a>,<a>,<a>,<a>}",
                "{{<a!>},{<a!>},{<a!>},{<ab>}}",
                "{<<<<>}", "{<{!>}>}"
               ]
    e, g = eval_group(group)
    println("$group: $e $(sum(e)) $g")
  end
  input = readline("input")
  e, g = eval_group(input)
  println("$(sum(e)) $g")
end

main()
