-- Day 13: Point of Incidence
-- Part 1: Find reflection lines in patterns
-- Part 2: Find reflections with exactly one smudge

import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (transpose)

input :: String
input = unsafePerformIO $ readInput 2023 13

type Pattern = [String]

parsePatterns :: String -> [Pattern]
parsePatterns str = map lines $ splitOn "\n\n" str
  where
    splitOn delim s = case breakOn delim s of
        (chunk, "") -> [chunk]
        (chunk, rest) -> chunk : splitOn delim (drop (length delim) rest)
    
    breakOn delim str' = go [] str'
      where
        go acc s
            | take (length delim) s == delim = (reverse acc, s)
            | null s = (reverse acc, "")
            | otherwise = go (head s : acc) (tail s)

-- Check if pattern reflects at position (number of rows/cols before line)
reflects :: Int -> Pattern -> Int -> Bool
reflects smudges pattern pos = smudgeCount == smudges
  where
    above = reverse $ take pos pattern
    below = drop pos pattern
    pairs = zip above below
    differences = sum [length $ filter id $ zipWith (/=) a b | (a, b) <- pairs]
    smudgeCount = differences

-- Find reflection line (returns 0 if not found)
findReflection :: Int -> Pattern -> Int
findReflection smudges pattern = 
    case filter (\p -> reflects smudges pattern p) [1..length pattern - 1] of
        (p:_) -> p
        [] -> 0

-- Score a pattern
scorePattern :: Int -> Pattern -> Int
scorePattern smudges pattern = 
    case findReflection smudges pattern of
        0 -> findReflection smudges (transpose pattern)
        n -> 100 * n

part1 :: Int
part1 = sum $ map (scorePattern 0) $ parsePatterns input

part2 :: Int
part2 = sum $ map (scorePattern 1) $ parsePatterns input
