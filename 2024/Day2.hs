-- Day 2: Red-Nosed Reports
-- Part 1: Count safe reports (gradually increasing/decreasing by 1-3)
-- Part 2: Allow removing one bad level

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [[Int]]
input = unsafePerformIO $ do
    lines <- readInputLines 2024 2
    return [map read $ words line | line <- lines]

isSafe :: [Int] -> Bool
isSafe levels = (allIncreasing || allDecreasing) && validDiffs
  where
    diffs = zipWith (-) (tail levels) levels
    allIncreasing = all (> 0) diffs
    allDecreasing = all (< 0) diffs
    validDiffs = all (\d -> abs d >= 1 && abs d <= 3) diffs

isSafeWithDampener :: [Int] -> Bool
isSafeWithDampener levels = isSafe levels || any isSafe removedOne
  where
    removedOne = [take i levels ++ drop (i + 1) levels | i <- [0..length levels - 1]]

part1 :: Int
part1 = length $ filter isSafe input

part2 :: Int
part2 = length $ filter isSafeWithDampener input
