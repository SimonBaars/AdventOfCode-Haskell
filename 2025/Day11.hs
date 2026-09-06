-- Day 11: Reactor
-- Part 1: Count paths from "you" to "out"
-- Part 2: Count paths through two waypoints

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Map as M
import qualified Data.Set as S

input :: [(String, [String])]
input = unsafePerformIO $ do
    lines <- readInputLines 2025 11
    return [parseLine line | line <- lines]
  where
    parseLine line = (device, outputs)
      where
        (device:rest) = words line
        outputs = rest

-- Count paths using DFS with memoization
countPaths :: M.Map String [String] -> String -> String -> Integer
countPaths graph start end
    | start == end = 1
    | M.notMember start graph = 0
    | otherwise = sum [countPaths graph next end | next <- graph M.! start]

part1 :: Integer
part1 = countPaths graph "you" "out"
  where
    graph = M.fromList input

part2 :: Integer
part2 = route1 + route2
  where
    graph = M.fromList input
    route1 = countPaths graph "svr" "dac" * 
            countPaths graph "dac" "fft" * 
            countPaths graph "fft" "out"
    route2 = countPaths graph "svr" "fft" * 
            countPaths graph "fft" "dac" * 
            countPaths graph "dac" "out"
