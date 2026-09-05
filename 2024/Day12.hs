-- Day 12: Garden Groups
-- Part 1: Total fencing cost (area * perimeter)
-- Part 2: Bulk discount (area * sides)

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Set as S

input :: [String]
input = unsafePerformIO $ readInputLines 2024 12

type Pos = (Int, Int)

-- Find all regions using flood fill
findRegions :: [String] -> [[Pos]]
findRegions grid = go S.empty allPositions
  where
    rows = length grid
    cols = length (head grid)
    allPositions = [(r, c) | r <- [0..rows-1], c <- [0..cols-1]]
    
    go visited [] = []
    go visited (pos:rest)
        | S.member pos visited = go visited rest
        | otherwise = region : go (S.union visited (S.fromList region)) rest
      where
        region = floodFill pos
    
    floodFill start = go' [start] S.empty
      where
        plantType = grid !! fst start !! snd start
        
        go' [] found = S.toList found
        go' (pos:queue) found
            | S.member pos found = go' queue found
            | otherwise = go' (queue ++ validNeighbors) (S.insert pos found)
          where
            validNeighbors = [n | n <- neighbors pos, valid n, 
                             grid !! fst n !! snd n == plantType]
    
    neighbors (r, c) = [(r-1, c), (r+1, c), (r, c-1), (r, c+1)]
    valid (r, c) = r >= 0 && r < rows && c >= 0 && c < cols

-- Calculate perimeter of a region
perimeter :: [String] -> [Pos] -> Int
perimeter grid region = sum [4 - adjacentCount pos | pos <- region]
  where
    regionSet = S.fromList region
    adjacentCount pos = length [n | n <- neighbors pos, S.member n regionSet]
    neighbors (r, c) = [(r-1, c), (r+1, c), (r, c-1), (r, c+1)]

-- Count corners (= number of sides)
countCorners :: [Pos] -> Int
countCorners region = sum [cornersAt pos | pos <- region]
  where
    regionSet = S.fromList region
    
    cornersAt (r, c) = length [corner | corner <- corners, corner]
      where
        -- Check 4 possible corners
        n = (r-1, c) `S.member` regionSet
        s = (r+1, c) `S.member` regionSet
        e = (r, c+1) `S.member` regionSet
        w = (r, c-1) `S.member` regionSet
        ne = (r-1, c+1) `S.member` regionSet
        nw = (r-1, c-1) `S.member` regionSet
        se = (r+1, c+1) `S.member` regionSet
        sw = (r+1, c-1) `S.member` regionSet
        
        -- External corners
        corners = [not n && not e,  -- NE external
                  not n && not w,  -- NW external
                  not s && not e,  -- SE external
                  not s && not w,  -- SW external
                  -- Internal corners
                  n && e && not ne,
                  n && w && not nw,
                  s && e && not se,
                  s && w && not sw]

part1 :: Int
part1 = sum [length region * perimeter input region | region <- findRegions input]

part2 :: Int
part2 = sum [length region * countCorners region | region <- findRegions input]
