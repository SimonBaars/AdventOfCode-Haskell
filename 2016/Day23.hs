import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

-- After toggle phase, program computes a! + (product of the two constants near the end)
input :: [String]
input = unsafePerformIO $ readInputLines 2016 23

constants :: (Int, Int)
constants =
  let nums = [read w | l <- input, let ws = words l, length ws >= 2,
                       w <- [ws !! 1], all (`elem` "0123456789-") w, w /= "0", w /= "1", w /= "-16"]
      -- last two positive multi-digit/literals used in the addend loop: cpy 93 c / jnz 80 d
      pos = [n | n <- nums, n > 1]
  in (pos !! (length pos - 2), pos !! (length pos - 1))

factorial :: Int -> Int
factorial n = product [1..n]

solve :: Int -> Int
solve a0 =
  let (c, d) = constants
  in factorial a0 + c * d

part1 :: Int
part1 = solve 7

part2 :: Int
part2 = solve 12
