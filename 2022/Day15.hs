-- Day 15: Beacon Exclusion Zone
-- Part 1: Count positions in row y=2000000 where beacon can't be
-- Part 2: Find tuning frequency of distress beacon

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (sort, nub)

type Pos = (Int, Int)

input :: [(Pos, Pos)]
input = unsafePerformIO $ do
    lines <- readInputLines 2022 15
    return [parseLine line | line <- lines]
  where
    parseLine line = ((sx, sy), (bx, by))
      where
        parts = words line
        sx = read $ init $ drop 2 $ parts !! 2
        sy = read $ init $ drop 2 $ parts !! 3
        bx = read $ init $ drop 2 $ parts !! 8
        by = read $ drop 2 $ parts !! 9

-- Manhattan distance
manhattan :: Pos -> Pos -> Int
manhattan (x1, y1) (x2, y2) = abs (x1 - x2) + abs (y1 - y2)

-- Get range of x values covered by a sensor at a given y
coverageAtY :: Pos -> Pos -> Int -> Maybe (Int, Int)
coverageAtY sensor beacon y
    | dy > dist = Nothing
    | otherwise = Just (sx - dx, sx + dx)
  where
    (sx, sy) = sensor
    dist = manhattan sensor beacon
    dy = abs (sy - y)
    dx = dist - dy

-- Merge overlapping ranges
mergeRanges :: [(Int, Int)] -> [(Int, Int)]
mergeRanges [] = []
mergeRanges ranges = go $ sort ranges
  where
    go [] = []
    go [r] = [r]
    go ((a1, b1):(a2, b2):rest)
        | b1 >= a2 - 1 = go ((a1, max b1 b2):rest)
        | otherwise = (a1, b1) : go ((a2, b2):rest)

part1 :: Int
part1 = sum [b - a | (a, b) <- merged] - length beaconsInRow
  where
    targetY = 2000000
    ranges = [r | (sensor, beacon) <- input, Just r <- [coverageAtY sensor beacon targetY]]
    merged = mergeRanges ranges
    beaconsInRow = nub [bx | (_, (bx, by)) <- input, by == targetY, 
                        any (\(a, b) -> bx >= a && bx <= b) merged]

part2 :: Integer
part2 = toInteger x * 4000000 + toInteger y
  where
    maxCoord = 4000000
    (x, y) = head [(x, y) | y <- [0..maxCoord], 
                            let ranges = mergeRanges [r | (sensor, beacon) <- input, 
                                                       Just r <- [coverageAtY sensor beacon y]],
                            x <- findGaps ranges 0 maxCoord,
                            x >= 0 && x <= maxCoord]
    
    findGaps [] _ _ = []
    findGaps ((a, b):rest) start end
        | start < a = start : findGaps ((a, b):rest) (a + 1) end
        | otherwise = findGaps rest (b + 1) end
