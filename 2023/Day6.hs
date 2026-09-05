-- Day 6: Wait For It
-- Part 1: Product of ways to win each race
-- Part 2: Ways to win the single combined race

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [String]
input = unsafePerformIO $ readInputLines 2023 6

parseInput :: [String] -> ([Int], [Int])
parseInput [timeLine, distLine] = (times, dists)
  where
    times = map read $ tail $ words timeLine
    dists = map read $ tail $ words distLine

-- Count ways to beat the record distance
waysToWin :: Int -> Int -> Int
waysToWin time record = length [hold | hold <- [1..time-1], hold * (time - hold) > record]

part1 :: Int
part1 = product [waysToWin t d | (t, d) <- zip times dists]
  where
    (times, dists) = parseInput input

part2 :: Int
part2 = waysToWin time dist
  where
    [timeLine, distLine] = input
    time = read $ concat $ tail $ words timeLine
    dist = read $ concat $ tail $ words distLine
