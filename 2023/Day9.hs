-- Day 9: Mirage Maintenance
-- Part 1: Extrapolate next values in sequences
-- Part 2: Extrapolate previous values

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [[Int]]
input = unsafePerformIO $ do
    lines <- readInputLines 2023 9
    return [map read $ words line | line <- lines]

-- Calculate differences between consecutive elements
differences :: [Int] -> [Int]
differences xs = zipWith (-) (tail xs) xs

-- Extrapolate next value in sequence
extrapolate :: [Int] -> Int
extrapolate xs
    | all (== 0) xs = 0
    | otherwise = last xs + extrapolate (differences xs)

part1 :: Int
part1 = sum $ map extrapolate input

part2 :: Int
part2 = sum $ map (extrapolate . reverse) input
