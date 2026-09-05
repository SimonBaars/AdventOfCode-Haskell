-- Day 4: Camp Cleanup
-- Part 1: Count pairs where one range fully contains the other
-- Part 2: Count pairs where ranges overlap at all

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [((Int, Int), (Int, Int))]
input = unsafePerformIO $ do
    lines <- readInputLines 2022 4
    return [parseLine line | line <- lines]
  where
    parseLine line = ((a, b), (c, d))
      where
        [first, second] = splitOn ',' line
        [a, b] = map read $ splitOn '-' first
        [c, d] = map read $ splitOn '-' second
    
    splitOn :: Char -> String -> [String]
    splitOn c str = case break (== c) str of
        (chunk, "") -> [chunk]
        (chunk, _:rest) -> chunk : splitOn c rest

-- Check if one range fully contains the other
fullyContains :: ((Int, Int), (Int, Int)) -> Bool
fullyContains ((a, b), (c, d)) = 
    (a <= c && b >= d) || (c <= a && d >= b)

-- Check if ranges overlap at all
overlaps :: ((Int, Int), (Int, Int)) -> Bool
overlaps ((a, b), (c, d)) = 
    not (b < c || d < a)

part1 :: Int
part1 = length $ filter fullyContains input

part2 :: Int
part2 = length $ filter overlaps input
