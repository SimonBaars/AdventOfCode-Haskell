-- Day 3: Lobby
-- Part 1: Sum maximum 2-digit joltages from each bank
-- Part 2: TBD

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.Char (digitToInt)
import Data.List (tails)

input :: [String]
input = unsafePerformIO $ readInputLines 2025 3

-- Find maximum 2-digit number in a string
maxJoltage :: String -> Int
maxJoltage str = maximum [d1 * 10 + d2 | (d1:d2:_) <- tails digits]
  where
    digits = map digitToInt str

part1 :: Int
part1 = sum [maxJoltage bank | bank <- input]

part2 :: Int
part2 = 0  -- TBD
