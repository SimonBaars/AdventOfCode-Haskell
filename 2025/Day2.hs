-- Day 2: Gift Shop
-- Part 1: Sum invalid IDs (repeated twice)
-- Part 2: Sum invalid IDs (repeated at least twice)

import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)

input :: String
input = unsafePerformIO $ readInput 2025 2

-- Parse ranges
parseRanges :: String -> [(Integer, Integer)]
parseRanges str = [parseRange r | r <- splitOn ',' str]
  where
    parseRange r = (read start, read end)
      where
        [start, end] = splitOn '-' r
    
    splitOn c s = case break (== c) s of
        (chunk, "") -> [chunk]
        (chunk, _:rest) -> chunk : splitOn c rest

-- Check if number is invalid (repeated pattern)
isInvalidPart1 :: Integer -> Bool
isInvalidPart1 n = any (\len -> s == replicate 2 (take len s)) [1..length s `div` 2]
  where
    s = show n

isInvalidPart2 :: Integer -> Bool
isInvalidPart2 n = any check [1..length s `div` 2]
  where
    s = show n
    check len = take (len * multiplier) s == concat (replicate multiplier (take len s))
      where
        multiplier = length s `div` len

part1 :: Integer
part1 = sum [n | (start, end) <- ranges, n <- [start..end], isInvalidPart1 n]
  where
    ranges = parseRanges $ head $ lines input

part2 :: Integer
part2 = sum [n | (start, end) <- ranges, n <- [start..end], isInvalidPart2 n]
  where
    ranges = parseRanges $ head $ lines input
