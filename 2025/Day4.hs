-- Day 4: Printing Department
-- Part 1: Count accessible paper rolls (< 4 adjacent rolls)
-- Part 2: TBD

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [String]
input = unsafePerformIO $ readInputLines 2025 4

type Pos = (Int, Int)

-- Count adjacent paper rolls
countAdjacent :: [String] -> Pos -> Int
countAdjacent grid (r, c) = length [() | (nr, nc) <- neighbors,
                                         valid nr nc,
                                         grid !! nr !! nc == '@']
  where
    rows = length grid
    cols = length (head grid)
    neighbors = [(r-1, c-1), (r-1, c), (r-1, c+1),
                (r, c-1),             (r, c+1),
                (r+1, c-1), (r+1, c), (r+1, c+1)]
    valid nr nc = nr >= 0 && nr < rows && nc >= 0 && nc < cols

-- Find accessible rolls
part1 :: Int
part1 = length [() | r <- [0..rows-1], c <- [0..cols-1],
                     grid !! r !! c == '@',
                     countAdjacent grid (r, c) < 4]
  where
    grid = input
    rows = length grid
    cols = length (head grid)

part2 :: Int
part2 = 0  -- TBD
