-- Day 8: Playground
-- Part 1: Product of 3 largest circuit sizes after 1000 connections
-- Part 2: TBD

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (sortBy)
import qualified Data.Map as M

input :: [(Int, Int, Int)]
input = unsafePerformIO $ do
    lines <- readInputLines 2025 8
    return [parseCoord line | line <- lines]
  where
    parseCoord line = (read x, read y, read z)
      where
        [x, y, z] = splitOn ',' line
    splitOn c str = case break (== c) str of
        (chunk, "") -> [chunk]
        (chunk, _:rest) -> chunk : splitOn c rest

-- Calculate 3D distance
distance :: (Int, Int, Int) -> (Int, Int, Int) -> Double
distance (x1, y1, z1) (x2, y2, z2) = 
    sqrt $ fromIntegral ((x2-x1)^2 + (y2-y1)^2 + (z2-z1)^2)

-- Find circuits using union-find
findCircuits :: [(Int, (Int, Int))] -> Int -> [Int]
findCircuits connections n = map length $ M.elems groups
  where
    parent = M.fromList [(i, i) | i <- [0..n-1]]
    
    find p i
        | p M.! i == i = i
        | otherwise = find p (p M.! i)
    
    union p (i, j) = M.insert (find p i) (find p j) p
    
    finalParent = foldl union parent [(i, j) | (_, (i, j)) <- connections]
    
    groups = M.fromListWith (++) [(find finalParent i, [i]) | i <- [0..n-1]]

part1 :: Int
part1 = product $ take 3 $ reverse $ sortBy compare circuitSizes
  where
    n = length input
    allPairs = [(distance (input !! i) (input !! j), (i, j)) | 
               i <- [0..n-1], j <- [i+1..n-1]]
    closest = take 1000 $ sortBy (\(d1, _) (d2, _) -> compare d1 d2) allPairs
    circuitSizes = findCircuits closest n

part2 :: Int
part2 = 0  -- TBD
