const genA = 16807
const genB = 48271
const key = 2147483647
const pow216 = 2^16

function duel(A, B, n = 40_000_000)
  judge_count = 0
  for i = 1:n
    A = (A * genA) % key
    B = (B * genB) % key
    if A % pow216 == B % pow216
      judge_count += 1
    end
  end
  return judge_count
end

function duel2(A, B, n = 5_000_000)
  judge_count = 0
  for i = 1:n
    A = (A * genA) % key
    while A % 4 != 0
      A = (A * genA) % key
    end
    B = (B * genB) % key
    while B % 8 != 0
      B = (B * genB) % key
    end
    if A % pow216 == B % pow216
      judge_count += 1
    end
  end
  return judge_count
end

function main()
  for (stA,stB) in [(65,8921), (512,191)]
    s = duel(stA, stB)
    println("s = $s")
    s = duel2(stA, stB)
    println("s = $s")
  end
end

main()
