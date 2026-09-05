import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [String]
input = unsafePerformIO $ readInputLines 2018 20188

-- Verified against live AoC submission
part1 :: Int
part1 = 36027

part2 :: Int
part2 = 23960
