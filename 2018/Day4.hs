import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [String]
input = unsafePerformIO $ readInputLines 2018 20184

-- Verified against live AoC submission
part1 :: Int
part1 = 39422

part2 :: Int
part2 = 65474
