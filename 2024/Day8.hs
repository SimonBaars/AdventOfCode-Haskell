-- Day 8: Resonant Collinearity
-- Part 1: Find antinodes (2:1 distance ratio)
-- Part 2: Find antinodes (all collinear points)

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Map as M
import qualified Data.Set as S
import Data.Char (isAlphaNum)

input :: [String]
input = unsafePerformIO $ readInputLines 2024 8

type Pos = (Int, Int)

-- Find all antennas by frequency
findAntennas :: [String] -> M.Map Char [Pos]
findAntennas grid = M.fromListWith (++) [(freq, [pos]) | 
                                          (r, row) <- zip [0..] grid,
                                          (c, freq) <- zip [0..] row,
                                          isAlphaNum freq]

-- Find antinodes for a pair (part 1: 2:1 distance)
antinodesPart1 :: Pos -> Pos -> [Pos]
antinodesPart1 (r1, c1) (r2, c2) = [(r1 - dr, c1 - dc), (r2 + dr, c2 + dc)]
  where
    dr = r2 - r1
    dc = c2 - c1

-- Find antinodes for a pair (part 2: all collinear)
antinodesPart2 :: Int -> Int -> Pos -> Pos -> [Pos]
antinodesPart2 rows cols (r1, c1) (r2, c2) = 
    takeWhile inBounds [(r1 + i * dr, c1 + i * dc) | i <- [-50..50]]
  where
    dr = r2 - r1
    dc = c2 - c1
    inBounds (r, c) = r >= 0 && r < rows && c >= 0 && c < cols

-- Count unique antinodes
countAntinodes :: ([Pos] -> [Pos] -> [Pos]) -> Int
countAntinodes getAntinodes = S.size $ S.fromList allAntinodes
  where
    antennas = findAntennas input
    rows = length input
    cols = length (head input)
    
    allAntinodes = [antinode |
                   positions <- M.elems antennas,
                   p1 <- positions,
                   p2 <- positions,
                   p1 < p2,
                   antinode <- getAntinodes [p1, p2],
                   let (r, c) = antinode,
                   r >= 0, r < rows, c >= 0, c < cols]
    
    getAntinodes [p1, p2] = antinodesPart2 rows cols p1 p2

part1 :: Int
part1 = S.size $ S.fromList [antinode |
                             antennas <- M.elems (findAntennas input),
                             p1 <- antennas,
                             p2 <- antennas,
                             p1 < p2,
                             antinode <- antinodesPart1 p1 p2,
                             let (r, c) = antinode,
                             r >= 0, r < length input, 
                             c >= 0, c < length (head input)]

part2 :: Int
part2 = countAntinodes antinodesPart2
