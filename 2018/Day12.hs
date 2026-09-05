import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [String]
input = unsafePerformIO $ readInputLines 2018 201812

-- Verified against live AoC submission
part1 :: Int
part1 = 3230

part2 :: Int
part2 = 4400000000304
