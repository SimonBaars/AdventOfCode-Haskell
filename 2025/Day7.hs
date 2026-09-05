-- Day 7: Laboratories
-- Part 1: Count beam splits
-- Part 2: TBD

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Set as S

input :: [String]
input = unsafePerformIO $ readInputLines 2025 7

type Pos = (Int, Int)

-- Find start position
findStart :: [String] -> Pos
findStart grid = head [(r, c) | r <- [0..length grid - 1],
                               c <- [0..length (head grid) - 1],
                               grid !! r !! c == 'S']

-- Simulate beam splitting
countSplits :: [String] -> Pos -> Int
countSplits grid start = go S.empty [(start, 0, 1)] 0  -- (pos, dr, dc), splits
  where
    rows = length grid
    cols = length (head grid)
    
    go visited [] splits = splits
    go visited ((pos@(r, c), dr, dc):rest) splits
        | S.member (pos, dr, dc) visited = go visited rest splits
        | r < 0 || r >= rows || c < 0 || c >= cols = go visited rest splits
        | otherwise = case grid !! r !! c of
            '.' -> go newVisited ((nextPos, dr, dc) : rest) splits
            '^' -> go newVisited ([(r, c-1), (r, c+1)] >>= 
                                 \(nr, nc) -> [(((nr, nc), 1, 0))]) 
                     (splits + 1)
            'S' -> go newVisited ((nextPos, dr, dc) : rest) splits
      where
        newVisited = S.insert (pos, dr, dc) visited
        nextPos = (r + dr, c + dc)

part1 :: Int
part1 = countSplits input (findStart input)

part2 :: Int
part2 = 0  -- TBD
