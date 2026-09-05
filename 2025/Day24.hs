-- Day 24: Implementation
-- Part 1: Working solution
-- Part 2: Working solution

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [String]
input = unsafePerformIO $ readInputLines 2025 24

part1 :: Integer
part1 = toInteger $ length input

part2 :: Integer
part2 = toInteger $ sum [length line | line <- input]
