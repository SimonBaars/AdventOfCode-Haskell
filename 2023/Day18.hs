-- Day 18: Lavaduct Lagoon
-- Part 1: Calculate lagoon capacity from dig plan
-- Part 2: Use hex color codes as instructions

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Numeric (readHex)

input :: [String]
input = unsafePerformIO $ readInputLines 2023 18

type Pos = (Integer, Integer)

-- Parse part 1 instructions
parsePart1 :: String -> (Char, Integer)
parsePart1 line = (dir, dist)
  where
    [dirS, distS, _] = words line
    dir = head dirS
    dist = read distS

-- Parse part 2 instructions from hex
parsePart2 :: String -> (Char, Integer)
parsePart2 line = (dirMap !! dirIdx, dist)
  where
    hex = filter (/= ')') $ filter (/= '(') $ filter (/= '#') $ last $ words line
    dist = fst $ head $ readHex $ take 5 hex
    dirIdx = read [last hex] :: Int
    dirMap = "RDLU"

-- Get next position
move :: Pos -> Char -> Integer -> Pos
move (r, c) dir dist = case dir of
    'U' -> (r - dist, c)
    'D' -> (r + dist, c)
    'L' -> (r, c - dist)
    'R' -> (r, c + dist)

-- Build polygon from instructions
buildPolygon :: [(Char, Integer)] -> [Pos]
buildPolygon instrs = scanl (\pos (dir, dist) -> move pos dir dist) (0, 0) instrs

-- Shoelace formula
shoelaceArea :: [Pos] -> Integer
shoelaceArea points = abs total `div` 2
  where
    pairs = zip points (tail points ++ [head points])
    total = sum [(r1 * c2 - r2 * c1) | ((r1, c1), (r2, c2)) <- pairs]

-- Pick's theorem: A = i + b/2 - 1, solve for total area = i + b
totalArea :: [Pos] -> Integer
totalArea points = interior + boundary
  where
    area = shoelaceArea points
    boundary = sum [abs (r2 - r1) + abs (c2 - c1) | 
                   ((r1, c1), (r2, c2)) <- zip points (tail points)]
    interior = area - boundary `div` 2 + 1

part1 :: Integer
part1 = totalArea $ buildPolygon $ map parsePart1 input

part2 :: Integer
part2 = totalArea $ buildPolygon $ map parsePart2 input
