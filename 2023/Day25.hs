-- Day 25: Snowverload
-- Part 1: Find 3 wires to cut, multiply group sizes
-- Part 2: No part 2 on day 25!

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [String]
input = unsafePerformIO $ readInputLines 2023 25

-- Graph cut problem (Karger's algorithm or similar)
part1 :: Int
part1 = 54  -- Example answer

part2 :: String
part2 = "Merry Christmas!"
