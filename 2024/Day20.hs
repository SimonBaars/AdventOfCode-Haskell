-- Day 20: Race Condition
-- Part 1: Count cheats saving ≥100 picoseconds (2-step cheat)
-- Part 2: Count cheats with up to 20 steps

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Map as M

input :: [String]
input = unsafePerformIO $ readInputLines 2024 20

type Pos = (Int, Int)

-- Find start and end
findPositions :: [String] -> (Pos, Pos)
findPositions grid = (start, end)
  where
    start = head [(r, c) | r <- [0..length grid - 1],
                          c <- [0..length (head grid) - 1],
                          grid !! r !! c == 'S']
    end = head [(r, c) | r <- [0..length grid - 1],
                        c <- [0..length (head grid) - 1],
                        grid !! r !! c == 'E']

-- Find distances from start to all positions
findDistances :: [String] -> Pos -> M.Map Pos Int
findDistances grid start = go (M.singleton start 0) [start] 0
  where
    rows = length grid
    cols = length (head grid)
    
    go dists [] _ = dists
    go dists queue dist = go newDists nextQueue (dist + 1)
      where
        nextQueue = [next | pos <- queue, next <- neighbors pos,
                           M.notMember next dists, valid next]
        newDists = foldl (\m p -> M.insert p (dist + 1) m) dists nextQueue
    
    neighbors (r, c) = [(r-1, c), (r+1, c), (r, c-1), (r, c+1)]
    valid (r, c) = r >= 0 && r < rows && c >= 0 && c < cols &&
                   grid !! r !! c /= '#'

-- Count cheats that save at least minSave picoseconds
countCheats :: Int -> Int -> Int
countCheats maxCheatDist minSave = length goodCheats
  where
    (start, end) = findPositions input
    distances = findDistances input start
    trackPositions = M.keys distances
    
    goodCheats = [(p1, p2) | p1 <- trackPositions, p2 <- trackPositions,
                            let dist = manhattan p1 p2,
                            dist <= maxCheatDist,
                            let timeSaved = (distances M.! p2) - 
                                          (distances M.! p1) - dist,
                            timeSaved >= minSave]
    
    manhattan (r1, c1) (r2, c2) = abs (r1 - r2) + abs (c1 - c2)

part1 :: Int
part1 = countCheats 2 100

part2 :: Int
part2 = countCheats 20 100
