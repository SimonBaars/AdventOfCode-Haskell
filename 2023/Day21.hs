-- Day 21: Step Counter
-- Part 1: Reachable plots in 64 steps
-- Part 2: Infinite grid with 26501365 steps

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Set as S

input :: [String]
input = unsafePerformIO $ readInputLines 2023 21

type Pos = (Int, Int)

findStart :: [String] -> Pos
findStart grid = head [(r, c) | r <- [0..length grid - 1],
                                c <- [0..length (head grid) - 1],
                                grid !! r !! c == 'S']

-- BFS for reachable positions
reachable :: [String] -> Int -> Int
reachable grid steps = S.size $ (!! steps) $ iterate step1 (S.singleton start)
  where
    start = findStart grid
    rows = length grid
    cols = length (head grid)
    
    step1 positions = S.fromList [next | pos <- S.toList positions,
                                         next <- neighbors pos,
                                         valid next]
    
    neighbors (r, c) = [(r-1, c), (r+1, c), (r, c-1), (r, c+1)]
    
    valid (r, c) = r >= 0 && r < rows && c >= 0 && c < cols && 
                   grid !! r !! c /= '#'

part1 :: Int
part1 = reachable input 64

-- Part 2: Infinite grid - use diamond pattern formula
part2 :: Integer
part2 = reachableInfinite input 26501365
  where
    reachableInfinite grid steps = 
        let size = toInteger $ length grid
            quotient = toInteger steps `div` size
            remainder = toInteger steps `mod` size
            -- Sample values at remainder, remainder+size, remainder+2*size
            vals = [toInteger $ reachable grid (fromInteger $ remainder + i * size) | i <- [0..2]]
            -- Fit quadratic: f(n) = a*n^2 + b*n + c
            c = vals !! 0
            a = ((vals !! 2) - 2 * (vals !! 1) + c) `div` 2
            b = (vals !! 1) - c - a
        in a * quotient * quotient + b * quotient + c
