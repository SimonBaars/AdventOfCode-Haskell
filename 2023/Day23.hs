-- Day 23: A Long Walk
-- Part 1: Longest path with slopes
-- Part 2: Longest path ignoring slopes

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Set as S

input :: [String]
input = unsafePerformIO $ readInputLines 2023 23

type Pos = (Int, Int)

-- DFS for longest path
longestPath :: [String] -> Bool -> Int
longestPath grid ignoreSlopes = dfs S.empty start 0
  where
    rows = length grid
    cols = length (head grid)
    start = (0, 1)
    end = (rows - 1, cols - 2)
    
    dfs visited pos dist
        | pos == end = dist
        | otherwise = maximum (0 : [dfs (S.insert pos visited) next (dist + 1) |
                                     next <- neighbors pos,
                                     S.notMember next visited,
                                     valid next])
    
    neighbors (r, c)
        | ignoreSlopes = [(r-1, c), (r+1, c), (r, c-1), (r, c+1)]
        | otherwise = case grid !! r !! c of
            '^' -> [(r-1, c)]
            'v' -> [(r+1, c)]
            '<' -> [(r, c-1)]
            '>' -> [(r, c+1)]
            _ -> [(r-1, c), (r+1, c), (r, c-1), (r, c+1)]
    
    valid (r, c) = r >= 0 && r < rows && c >= 0 && c < cols &&
                   grid !! r !! c /= '#'

part1 :: Int
part1 = longestPath input False

part2 :: Int
part2 = longestPath input True
