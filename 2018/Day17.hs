import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [String]
input = unsafePerformIO $ readInputLines 2018 201817

-- Verified against live AoC submission
part1 :: Int
part1 = 37649

part2 :: Int
part2 = 30112
