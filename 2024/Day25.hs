-- Day 25: Code Chronicle
-- Part 1: Count key/lock pairs that fit
-- Part 2: No part 2 on day 25!

import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)

input :: String
input = unsafePerformIO $ readInput 2024 25

data Schematic = Lock [Int] | Key [Int] deriving Show

-- Parse schematics
parseSchematics :: String -> [Schematic]
parseSchematics str = [parseSchematic s | s <- splitOn "\n\n" str]
  where
    parseSchematic s
        | head (lines s) == "#####" = Lock (heights s)
        | otherwise = Key (heights s)
    
    heights s = [length (filter (== '#') col) - 1 | 
                col <- transpose (lines s)]
    
    transpose [] = []
    transpose ([] : _) = []
    transpose xs = map head xs : transpose (map tail xs)
    
    splitOn delim s' = case breakOn delim s' of
        (chunk, "") -> [chunk]
        (chunk, rest) -> chunk : splitOn delim (drop (length delim) rest)
    
    breakOn delim str = go [] str
      where
        go acc s
            | take (length delim) s == delim = (reverse acc, s)
            | null s = (reverse acc, "")
            | otherwise = go (head s : acc) (tail s)

-- Check if key fits lock
fits :: Schematic -> Schematic -> Bool
fits (Lock lockHeights) (Key keyHeights) = 
    all (<= 5) $ zipWith (+) lockHeights keyHeights
fits _ _ = False

part1 :: Int
part1 = length [(lock, key) | lock <- schematics, key <- schematics, 
                              fits lock key]
  where
    schematics = parseSchematics input

part2 :: String
part2 = "Merry Christmas!"
