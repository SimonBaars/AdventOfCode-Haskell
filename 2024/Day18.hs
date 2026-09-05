-- Day 18: RAM Run
-- Part 1: Shortest path after 1024 bytes
-- Part 2: First byte that blocks path

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Set as S

input :: [String]
input = unsafePerformIO $ readInputLines 2024 18

type Pos = (Int, Int)

-- Parse byte positions
parseBytes :: [String] -> [Pos]
parseBytes lines = [(read x, read y) | line <- lines, 
                    let [x, y] = splitOn ',' line]
  where
    splitOn c str = case break (== c) str of
        (chunk, "") -> [chunk]
        (chunk, _:rest) -> chunk : splitOn c rest

-- BFS shortest path
shortestPath :: Int -> S.Set Pos -> Maybe Int
shortestPath size corrupted = bfs (S.singleton (0, 0)) [(0, 0)] 0
  where
    target = (size, size)
    
    bfs visited [] _ = Nothing
    bfs visited queue dist
        | target `elem` queue = Just dist
        | otherwise = bfs (S.union visited (S.fromList nextQueue)) 
                          nextQueue (dist + 1)
      where
        nextQueue = [next | pos <- queue, next <- neighbors pos,
                           valid next, S.notMember next visited,
                           S.notMember next corrupted]
    
    neighbors (x, y) = [(x-1, y), (x+1, y), (x, y-1), (x, y+1)]
    valid (x, y) = x >= 0 && x <= size && y >= 0 && y <= size

part1 :: Int
part1 = case shortestPath 70 (S.fromList $ take 1024 bytes) of
    Just d -> d
    Nothing -> -1
  where
    bytes = parseBytes input

part2 :: String
part2 = show firstBlocking
  where
    bytes = parseBytes input
    firstBlocking = head [b | i <- [1024..length bytes],
                             let b = bytes !! (i - 1),
                             shortestPath 70 (S.fromList $ take i bytes) == Nothing]
