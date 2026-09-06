-- Day 14: Parabolic Reflector Dish
-- Part 1: Tilt north and calculate load
-- Part 2: 1 billion cycles with cycle detection

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (transpose, sort)
import qualified Data.Map as M

input :: [String]
input = unsafePerformIO $ readInputLines 2023 14

-- Tilt a single row/column to slide rocks left
tiltLeft :: String -> String
tiltLeft = concat . map sortSegment . splitOn '#'
  where
    splitOn c [] = [[]]
    splitOn c (x:xs)
        | x == c = [] : splitOn c xs
        | otherwise = (x : head rest) : tail rest
      where rest = splitOn c xs
    
    sortSegment s = reverse $ sort s  -- 'O' before '.'

-- Tilt entire grid north
tiltNorth :: [String] -> [String]
tiltNorth = transpose . map tiltLeft . transpose

-- Tilt in all 4 directions (one cycle)
cycle4 :: [String] -> [String]
cycle4 = tiltEast . tiltSouth . tiltWest . tiltNorth
  where
    tiltWest = map tiltLeft
    tiltSouth = transpose . map (reverse . tiltLeft . reverse) . transpose
    tiltEast = map (reverse . tiltLeft . reverse)

-- Calculate load on north beams
calculateLoad :: [String] -> Int
calculateLoad grid = sum [length (filter (== 'O') row) * (rows - r) | 
                          (r, row) <- zip [0..] grid]
  where
    rows = length grid

-- Find cycle and calculate state after n iterations
findCycle :: [String] -> Integer -> Int
findCycle grid n = calculateLoad finalState
  where
    (cycleStart, cycleLen, states) = go M.empty grid 0
    remaining = (n - cycleStart) `mod` cycleLen
    finalIdx = cycleStart + remaining
    finalState = states M.! (fromInteger finalIdx)
    
    go seen g i
        | M.member g seen = (seen M.! g, i - seen M.! g, M.fromList [(v, k) | (k, v) <- M.toList seen])
        | otherwise = go (M.insert g i seen) (cycle4 g) (i + 1)

part1 :: Int
part1 = calculateLoad $ tiltNorth input

part2 :: Int
part2 = findCycle input 1000000000
