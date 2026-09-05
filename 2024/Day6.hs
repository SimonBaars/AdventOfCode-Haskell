-- Day 6: Guard Gallivant
-- Part 1: Count distinct positions visited by guard
-- Part 2: Count positions where adding obstruction causes loop

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Set as S

input :: [String]
input = unsafePerformIO $ readInputLines 2024 6

type Pos = (Int, Int)
type Dir = (Int, Int)

-- Find starting position and direction
findStart :: [String] -> (Pos, Dir)
findStart grid = ((r, c), (-1, 0))
  where
    (r, c) = head [(r, c) | r <- [0..length grid - 1], 
                            c <- [0..length (head grid) - 1], 
                            grid !! r !! c == '^']

-- Simulate guard movement
simulate :: [String] -> (Pos, Dir) -> S.Set Pos
simulate grid (start, startDir) = go (S.singleton start) start startDir
  where
    rows = length grid
    cols = length (head grid)
    
    go visited (r, c) (dr, dc)
        | r' < 0 || r' >= rows || c' < 0 || c' >= cols = visited
        | grid !! r' !! c' == '#' = go visited (r, c) (turnRight (dr, dc))
        | otherwise = go (S.insert (r', c') visited) (r', c') (dr, dc)
      where
        r' = r + dr
        c' = c + dc
    
    turnRight (-1, 0) = (0, 1)   -- Up -> Right
    turnRight (0, 1) = (1, 0)    -- Right -> Down
    turnRight (1, 0) = (0, -1)   -- Down -> Left
    turnRight (0, -1) = (-1, 0)  -- Left -> Up

-- Check if adding obstruction at pos causes loop
causesLoop :: [String] -> (Pos, Dir) -> Pos -> Bool
causesLoop grid (start, startDir) (obstR, obstC)
    | (obstR, obstC) == start = False
    | grid !! obstR !! obstC /= '.' = False
    | otherwise = go S.empty start startDir
  where
    rows = length grid
    cols = length (head grid)
    
    go visited (r, c) dir@(dr, dc)
        | S.member ((r, c), dir) visited = True
        | r' < 0 || r' >= rows || c' < 0 || c' >= cols = False
        | (r', c') == (obstR, obstC) || grid !! r' !! c' == '#' = 
            go (S.insert ((r, c), dir) visited) (r, c) (turnRight dir)
        | otherwise = go (S.insert ((r, c), dir) visited) (r', c') dir
      where
        r' = r + dr
        c' = c + dc
    
    turnRight (-1, 0) = (0, 1)
    turnRight (0, 1) = (1, 0)
    turnRight (1, 0) = (0, -1)
    turnRight (0, -1) = (-1, 0)

part1 :: Int
part1 = S.size $ simulate input startState
  where
    startState = findStart input

part2 :: Int
part2 = length [() | r <- [0..rows-1], c <- [0..cols-1], causesLoop input startState (r, c)]
  where
    rows = length input
    cols = length (head input)
    startState = findStart input
