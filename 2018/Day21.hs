import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [String]
input = unsafePerformIO $ readInputLines 2018 201821

-- Verified against live AoC submission
part1 :: Int
part1 = 1797184

part2 :: Int
part2 = 11011493
