-- Day 12: Hill Climbing Algorithm
-- Part 1: Shortest path from S to E
-- Part 2: Shortest path from any 'a' to E

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.Char (ord)
import qualified Data.Set as S
import qualified Data.Sequence as Seq
import Data.Sequence ((|>))

input :: [[Char]]
input = unsafePerformIO $ readInputLines 2022 12

type Pos = (Int, Int)

-- Find position of character in grid
findChar :: Char -> [[Char]] -> Pos
findChar c grid = head [(r, c) | r <- [0..rows-1], c <- [0..cols-1], grid !! r !! c == c]
  where
    rows = length grid
    cols = length (head grid)

-- Get height of a position
height :: [[Char]] -> Pos -> Int
height grid (r, c)
    | ch == 'S' = 0
    | ch == 'E' = 25
    | otherwise = ord ch - ord 'a'
  where
    ch = grid !! r !! c

-- BFS to find shortest path
bfs :: [[Char]] -> [Pos] -> Pos -> Int
bfs grid starts end = go (Seq.fromList [(s, 0) | s <- starts]) S.empty
  where
    rows = length grid
    cols = length (head grid)
    
    go Seq.Empty _ = -1
    go (curr Seq.:<| rest) visited
        | fst curr == end = snd curr
        | otherwise = go newQueue newVisited
      where
        pos = fst curr
        dist = snd curr
        neighbors = filter valid $ map (\(dr, dc) -> (fst pos + dr, snd pos + dc)) [(-1,0), (1,0), (0,-1), (0,1)]
        valid (r, c) = r >= 0 && r < rows && c >= 0 && c < cols
                    && S.notMember (r, c) visited
                    && height grid (r, c) <= height grid pos + 1
        newNeighbors = [(n, dist + 1) | n <- neighbors]
        newVisited = foldr S.insert visited neighbors
        newQueue = foldl (|>) rest newNeighbors

part1 :: Int
part1 = bfs input [findChar 'S' input] (findChar 'E' input)

part2 :: Int
part2 = bfs input starts (findChar 'E' input)
  where
    rows = length input
    cols = length (head input)
    starts = [(r, c) | r <- [0..rows-1], c <- [0..cols-1], 
              let ch = input !! r !! c in ch == 'a' || ch == 'S']
