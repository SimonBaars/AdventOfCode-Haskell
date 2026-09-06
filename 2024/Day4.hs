-- Day 4: Ceres Search
-- Part 1: Count all occurrences of "XMAS" in any direction
-- Part 2: Count X-shaped "MAS" patterns

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [String]
input = unsafePerformIO $ readInputLines 2024 4

-- Check if XMAS appears starting at (r, c) in direction (dr, dc)
checkXMAS :: [String] -> Int -> Int -> Int -> Int -> Bool
checkXMAS grid r c dr dc = all checkPos $ zip [0..3] "XMAS"
  where
    rows = length grid
    cols = length (head grid)
    checkPos (i, ch) = r' >= 0 && r' < rows && c' >= 0 && c' < cols && grid !! r' !! c' == ch
      where
        r' = r + i * dr
        c' = c + i * dc

-- Count XMAS in all 8 directions from position
countFromPos :: [String] -> Int -> Int -> Int
countFromPos grid r c = length $ filter id checks
  where
    directions = [(dr, dc) | dr <- [-1, 0, 1], dc <- [-1, 0, 1], dr /= 0 || dc /= 0]
    checks = [checkXMAS grid r c dr dc | (dr, dc) <- directions]

-- Check if X-MAS pattern exists centered at (r, c)
isXMAS :: [String] -> Int -> Int -> Bool
isXMAS grid r c
    | r < 1 || r >= rows - 1 || c < 1 || c >= cols - 1 = False
    | grid !! r !! c /= 'A' = False
    | otherwise = (diag1 == "MS" || diag1 == "SM") && (diag2 == "MS" || diag2 == "SM")
  where
    rows = length grid
    cols = length (head grid)
    diag1 = [grid !! (r-1) !! (c-1), grid !! (r+1) !! (c+1)]
    diag2 = [grid !! (r-1) !! (c+1), grid !! (r+1) !! (c-1)]

part1 :: Int
part1 = sum [countFromPos input r c | r <- [0..rows-1], c <- [0..cols-1]]
  where
    rows = length input
    cols = length (head input)

part2 :: Int
part2 = length [() | r <- [0..rows-1], c <- [0..cols-1], isXMAS input r c]
  where
    rows = length input
    cols = length (head input)
