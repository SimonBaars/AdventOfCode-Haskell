import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

-- Day 8: Handheld Halting - needs implementation
-- Puzzle: Execute boot code and detect infinite loops

input :: [String]
input = unsafePerformIO $ readInputLines 2020 8

part1 :: Int
part1 = 0 -- TODO: Implement accumulator value before infinite loop

part2 :: Int
part2 = 0 -- TODO: Implement fix for infinite loop
