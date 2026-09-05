-- Day 10: Hoof It
-- Part 1: Sum of trailhead scores (unique endpoints)
-- Part 2: Sum of trailhead ratings (distinct paths)

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.Char (digitToInt)
import qualified Data.Set as S

input :: [[Int]]
input = unsafePerformIO $ do
    lines <- readInputLines 2024 10
    return [map digitToInt line | line <- lines]

type Pos = (Int, Int)

-- Find all trailheads (height 0)
findTrailheads :: [[Int]] -> [Pos]
findTrailheads grid = [(r, c) | r <- [0..rows-1], c <- [0..cols-1], 
                                grid !! r !! c == 0]
  where
    rows = length grid
    cols = length (head grid)

-- BFS to find reachable 9s (part 1)
trailheadScore :: [[Int]] -> Pos -> Int
trailheadScore grid start = S.size $ reachableNines S.empty [start] 0
  where
    rows = length grid
    cols = length (head grid)
    
    reachableNines found [] _ = found
    reachableNines found positions height
        | height == 9 = S.union found (S.fromList positions)
        | otherwise = reachableNines found nextPositions (height + 1)
      where
        nextPositions = [next | pos <- positions, next <- neighbors pos,
                               valid next, grid !! fst next !! snd next == height + 1]
    
    neighbors (r, c) = [(r-1, c), (r+1, c), (r, c-1), (r, c+1)]
    valid (r, c) = r >= 0 && r < rows && c >= 0 && c < cols

-- DFS to count distinct paths (part 2)
trailheadRating :: [[Int]] -> Pos -> Int
trailheadRating grid start = countPaths start 0
  where
    rows = length grid
    cols = length (head grid)
    
    countPaths pos height
        | height == 9 = 1
        | otherwise = sum [countPaths next (height + 1) | 
                          next <- neighbors pos,
                          valid next,
                          grid !! fst next !! snd next == height + 1]
    
    neighbors (r, c) = [(r-1, c), (r+1, c), (r, c-1), (r, c+1)]
    valid (r, c) = r >= 0 && r < rows && c >= 0 && c < cols

part1 :: Int
part1 = sum [trailheadScore input th | th <- findTrailheads input]

part2 :: Int
part2 = sum [trailheadRating input th | th <- findTrailheads input]
