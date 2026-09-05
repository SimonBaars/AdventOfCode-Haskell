-- Day 1: Historian Hysteria
-- Part 1: Total distance between sorted pairs
-- Part 2: Similarity score (left * frequency in right)

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (sort)

input :: [(Int, Int)]
input = unsafePerformIO $ do
    lines <- readInputLines 2024 1
    return [parseLine line | line <- lines]
  where
    parseLine line = (read $ head ws, read $ ws !! 1)
      where ws = words line

part1 :: Int
part1 = sum $ zipWith (\a b -> abs (a - b)) leftSorted rightSorted
  where
    (left, right) = unzip input
    leftSorted = sort left
    rightSorted = sort right

part2 :: Int
part2 = sum [l * count l right | l <- left]
  where
    (left, right) = unzip input
    count x xs = length $ filter (== x) xs
