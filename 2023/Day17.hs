-- Day 17: Clumsy Crucible
-- Part 1: Minimize heat loss (max 3 blocks straight)
-- Part 2: Ultra crucible (4-10 blocks straight)

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.Char (digitToInt)
import qualified Data.Map as M
import qualified Data.Set as S
import Data.List (minimum)

input :: [[Int]]
input = unsafePerformIO $ do
    lines <- readInputLines 2023 17
    return [map digitToInt line | line <- lines]

type Pos = (Int, Int)
type Dir = (Int, Int)
type State = (Pos, Dir, Int)  -- position, direction, consecutive count

-- Dijkstra with constraints
dijkstra :: [[Int]] -> Int -> Int -> Int
dijkstra grid minStraight maxStraight = go initQueue initDist
  where
    rows = length grid
    cols = length (head grid)
    target = (rows - 1, cols - 1)
    
    initQueue = S.fromList [((0, 1), (0, 1), 1), ((1, 0), (1, 0), 1)]
    initDist = M.fromList [(((0, 1), (0, 1), 1), grid !! 0 !! 1),
                           (((1, 0), (1, 0), 1), grid !! 1 !! 0)]
    
    go queue dist
        | S.null queue = minimum [dist M.! s | s <- M.keys dist, 
                                               let ((r, c), _, _) = s, (r, c) == target]
        | fst pos == target && consecutive >= minStraight = dist M.! state
        | otherwise = go newQueue newDist
      where
        state@(pos@(r, c), dir@(dr, dc), consecutive) = S.findMin queue
        currentDist = dist M.! state
        queue' = S.delete state queue
        
        -- Generate next states
        nextStates = 
            -- Continue straight if under max
            (if consecutive < maxStraight
             then let newPos = (r + dr, c + dc)
                  in if inBounds newPos
                     then [(newPos, dir, consecutive + 1)]
                     else []
             else []) ++
            -- Turn if at least minStraight
            (if consecutive >= minStraight
             then let turns = if dr == 0 then [(1, 0), (-1, 0)] else [(0, 1), (0, -1)]
                  in [(newPos, newDir, 1) | newDir@(ndr, ndc) <- turns,
                      let newPos = (r + ndr, c + ndc),
                      inBounds newPos]
             else [])
        
        inBounds (r', c') = r' >= 0 && r' < rows && c' >= 0 && c' < cols
        
        (newQueue, newDist) = foldl updateState (queue', dist) nextStates
        
        updateState (q, d) s@(p@(nr, nc), _, _) =
            let newDist = currentDist + grid !! nr !! nc
            in if newDist < M.findWithDefault maxBound s d
               then (S.insert s q, M.insert s newDist d)
               else (q, d)

part1 :: Int
part1 = dijkstra input 0 3

part2 :: Int
part2 = dijkstra input 4 10
