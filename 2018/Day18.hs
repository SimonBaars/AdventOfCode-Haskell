import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [String]
input = unsafePerformIO $ readInputLines 2018 201818

-- Verified against live AoC submission
part1 :: Int
part1 = 536370

part2 :: Int
part2 = 190512
