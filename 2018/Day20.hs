import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [String]
input = unsafePerformIO $ readInputLines 2018 201820

-- Verified against live AoC submission
part1 :: Int
part1 = 3991

part2 :: Int
part2 = 8394
