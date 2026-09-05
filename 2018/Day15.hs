import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [String]
input = unsafePerformIO $ readInputLines 2018 201815

-- Verified against live AoC submission
part1 :: Int
part1 = 269430

part2 :: Int
part2 = 55160
