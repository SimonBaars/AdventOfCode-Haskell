-- Day 10: Pipe Maze
-- Part 1: Find farthest point in pipe loop from start
-- Part 2: Count tiles enclosed by the loop (Pick's theorem + Shoelace)

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Set as S
import qualified Data.Map as M
import Data.List (find)
import Data.Maybe (fromJust)

input :: [String]
input = unsafePerformIO $ readInputLines 2023 10

type Pos = (Int, Int)

-- Find starting position
findStart :: [String] -> Pos
findStart grid = head [(r, c) | r <- [0..length grid - 1], 
                                c <- [0..length (head grid) - 1], 
                                grid !! r !! c == 'S']

-- Get valid neighbors for a pipe at position
neighbors :: [String] -> Pos -> [Pos]
neighbors grid (r, c) = case pipe of
    '|' -> [(r-1, c), (r+1, c)]
    '-' -> [(r, c-1), (r, c+1)]
    'L' -> [(r-1, c), (r, c+1)]
    'J' -> [(r-1, c), (r, c-1)]
    '7' -> [(r+1, c), (r, c-1)]
    'F' -> [(r+1, c), (r, c+1)]
    'S' -> filter isConnected [(r-1, c), (r+1, c), (r, c-1), (r, c+1)]
    _ -> []
  where
    pipe = grid !! r !! c
    rows = length grid
    cols = length (head grid)
    
    isConnected (nr, nc)
        | nr < 0 || nr >= rows || nc < 0 || nc >= cols = False
        | otherwise = (r, c) `elem` neighbors grid (nr, nc)

-- Find the loop starting from S
findLoop :: [String] -> [Pos]
findLoop grid = start : go S.empty start (head validNext)
  where
    start = findStart grid
    validNext = neighbors grid start
    
    go visited curr next
        | next == start = []
        | otherwise = next : go (S.insert curr visited) next nextNext
      where
        nextNext = head $ filter (`S.notMember` visited) $ neighbors grid next

-- Shoelace formula for polygon area
shoelaceArea :: [Pos] -> Int
shoelaceArea points = abs total `div` 2
  where
    pairs = zip points (tail points ++ [head points])
    total = sum [(r1 * c2 - r2 * c1) | ((r1, c1), (r2, c2)) <- pairs]

-- Pick's theorem: A = i + b/2 - 1, solve for i
interiorPoints :: [Pos] -> Int
interiorPoints points = area - boundary `div` 2 + 1
  where
    area = shoelaceArea points
    boundary = length points

part1 :: Int
part1 = length (findLoop input) `div` 2

part2 :: Int
part2 = interiorPoints $ findLoop input
