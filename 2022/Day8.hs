-- Day 8: Treetop Tree House
-- Part 1: Count trees visible from outside the grid
-- Part 2: Find highest scenic score

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.Char (digitToInt)

input :: [[Int]]
input = unsafePerformIO $ do
    lines <- readInputLines 2022 8
    return [map digitToInt line | line <- lines]

-- Check if tree at (row, col) is visible from outside
isVisible :: [[Int]] -> Int -> Int -> Bool
isVisible grid row col = 
    visibleFromTop || visibleFromBottom || visibleFromLeft || visibleFromRight
  where
    height = grid !! row !! col
    visibleFromTop = all (< height) [grid !! r !! col | r <- [0..row-1]]
    visibleFromBottom = all (< height) [grid !! r !! col | r <- [row+1..length grid - 1]]
    visibleFromLeft = all (< height) [grid !! row !! c | c <- [0..col-1]]
    visibleFromRight = all (< height) [grid !! row !! c | c <- [col+1..length (head grid) - 1]]

-- Calculate scenic score for tree at (row, col)
scenicScore :: [[Int]] -> Int -> Int -> Int
scenicScore grid row col = up * down * left * right
  where
    height = grid !! row !! col
    up = viewDistance height $ reverse [grid !! r !! col | r <- [0..row-1]]
    down = viewDistance height [grid !! r !! col | r <- [row+1..length grid - 1]]
    left = viewDistance height $ reverse [grid !! row !! c | c <- [0..col-1]]
    right = viewDistance height [grid !! row !! c | c <- [col+1..length (head grid) - 1]]
    
    viewDistance h trees = case span (< h) trees of
        (visible, []) -> length visible
        (visible, _:_) -> length visible + 1

part1 :: Int
part1 = length [(r, c) | r <- [0..rows-1], c <- [0..cols-1], isVisible input r c]
  where
    rows = length input
    cols = length (head input)

part2 :: Int
part2 = maximum [scenicScore input r c | r <- [0..rows-1], c <- [0..cols-1]]
  where
    rows = length input
    cols = length (head input)
