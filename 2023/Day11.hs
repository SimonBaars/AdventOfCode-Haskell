-- Day 11: Cosmic Expansion
-- Part 1: Sum of distances between galaxies (expansion factor 2)
-- Part 2: Sum of distances (expansion factor 1000000)

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (transpose)

input :: [String]
input = unsafePerformIO $ readInputLines 2023 11

type Pos = (Int, Int)

-- Find all galaxy positions
findGalaxies :: [String] -> [Pos]
findGalaxies grid = [(r, c) | r <- [0..length grid - 1],
                              c <- [0..length (head grid) - 1],
                              grid !! r !! c == '#']

-- Find empty rows and columns
emptyRows :: [String] -> [Int]
emptyRows grid = [r | r <- [0..length grid - 1], all (== '.') (grid !! r)]

emptyCols :: [String] -> [Int]
emptyCols grid = [c | c <- [0..length (head grid) - 1], 
                      all (== '.') [grid !! r !! c | r <- [0..length grid - 1]]]

-- Calculate expanded Manhattan distance
expandedDistance :: Int -> [Int] -> [Int] -> Pos -> Pos -> Integer
expandedDistance expansion emptyR emptyC (r1, c1) (r2, c2) = 
    toInteger baseDist + toInteger (extraRows + extraCols) * toInteger (expansion - 1)
  where
    baseDist = abs (r1 - r2) + abs (c1 - c2)
    minR = min r1 r2
    maxR = max r1 r2
    minC = min c1 c2
    maxC = max c1 c2
    extraRows = length $ filter (\r -> r > minR && r < maxR) emptyR
    extraCols = length $ filter (\c -> c > minC && c < maxC) emptyC

-- Sum distances between all pairs
sumDistances :: Int -> Integer
sumDistances expansion = sum [expandedDistance expansion emptyR emptyC g1 g2 | 
                              (i, g1) <- zip [0..] galaxies,
                              g2 <- drop (i+1) galaxies]
  where
    galaxies = findGalaxies input
    emptyR = emptyRows input
    emptyC = emptyCols input

part1 :: Integer
part1 = sumDistances 2

part2 :: Integer
part2 = sumDistances 1000000
