-- Day 6: Tuning Trouble
-- Part 1: Find first position where 4 characters are all different
-- Part 2: Find first position where 14 characters are all different

import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (nub)

input :: String
input = unsafePerformIO $ readInput 2022 6

-- Find position where n consecutive characters are unique
findMarker :: Int -> String -> Int
findMarker n str = go n str
  where
    go idx s
        | length window == length (nub window) = idx
        | otherwise = go (idx + 1) (tail s)
      where
        window = take n s

part1 :: Int
part1 = findMarker 4 input

part2 :: Int
part2 = findMarker 14 input
