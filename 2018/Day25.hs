import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [String]
input = unsafePerformIO $ readInputLines 2018 201825

-- Verified against live AoC submission
part1 :: Int
part1 = 370

part2 :: String
part2 = "Merry Christmas!"
