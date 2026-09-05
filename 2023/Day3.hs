-- Day 3: Gear Ratios
-- Part 1: Sum part numbers adjacent to symbols
-- Part 2: Sum gear ratios (product of two numbers adjacent to *)

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.Char (isDigit)
import qualified Data.Set as S

input :: [String]
input = unsafePerformIO $ readInputLines 2023 3

-- Find all numbers with their positions
findNumbers :: [String] -> [(Int, Int, Int, Int)]  -- (row, startCol, endCol, value)
findNumbers grid = concatMap findInRow $ zip [0..] grid
  where
    findInRow (row, line) = go 0 line
      where
        go col [] = []
        go col (c:cs)
            | isDigit c = (row, col, endCol, num) : go (endCol + 1) (drop (length numStr - 1) cs)
            | otherwise = go (col + 1) cs
          where
            numStr = takeWhile isDigit (c:cs)
            num = read numStr
            endCol = col + length numStr - 1

-- Check if a number is adjacent to any symbol
hasAdjacentSymbol :: [String] -> (Int, Int, Int, Int) -> Bool
hasAdjacentSymbol grid (row, startCol, endCol, _) = any isSymbol adjacentPositions
  where
    rows = length grid
    cols = length (head grid)
    adjacentPositions = [(r, c) | r <- [row-1..row+1], c <- [startCol-1..endCol+1],
                                  r >= 0, r < rows, c >= 0, c < cols,
                                  not (r == row && c >= startCol && c <= endCol)]
    isSymbol (r, c) = let ch = grid !! r !! c in ch /= '.' && not (isDigit ch)

-- Find all gears and their adjacent numbers
findGears :: [String] -> [(Int, Int, Int, Int)] -> Int
findGears grid numbers = sum [n1 * n2 | gear <- gears, 
                                        let adj = adjacentNumbers gear numbers,
                                        length adj == 2,
                                        let [n1, n2] = adj]
  where
    rows = length grid
    cols = length (head grid)
    gears = [(r, c) | r <- [0..rows-1], c <- [0..cols-1], grid !! r !! c == '*']
    
    adjacentNumbers (gr, gc) nums = 
        [n | (r, startC, endC, n) <- nums,
             abs (r - gr) <= 1,
             any (\c -> abs (c - gc) <= 1) [startC..endC]]

part1 :: Int
part1 = sum [n | (_, _, _, n) <- numbers, hasAdjacentSymbol input (r, s, e, n)]
  where
    numbers = findNumbers input
    numbersWithCheck = [(r, s, e, n) | (r, s, e, n) <- numbers]

part2 :: Int
part2 = findGears input (findNumbers input)
