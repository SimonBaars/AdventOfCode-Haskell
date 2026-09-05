-- Day 3: Rucksack Reorganization
-- Part 1: Find common item in each rucksack's two compartments
-- Part 2: Find common item (badge) in each group of three rucksacks

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (intersect)
import Data.Char (ord, isUpper, isLower)

input :: [String]
input = unsafePerformIO $ readInputLines 2022 3

-- Calculate priority of an item
priority :: Char -> Int
priority c
    | isLower c = ord c - ord 'a' + 1
    | isUpper c = ord c - ord 'A' + 27
    | otherwise = 0

-- Find the common item in two compartments
findCommon :: String -> Char
findCommon rucksack = head common
  where
    half = length rucksack `div` 2
    (first, second) = splitAt half rucksack
    common = intersect first second

-- Find common item in three rucksacks
findBadge :: [String] -> Char
findBadge [r1, r2, r3] = head $ intersect r1 (intersect r2 r3)

-- Split list into chunks of size n
chunksOf :: Int -> [a] -> [[a]]
chunksOf _ [] = []
chunksOf n xs = take n xs : chunksOf n (drop n xs)

part1 :: Int
part1 = sum $ map (priority . findCommon) input

part2 :: Int
part2 = sum $ map (priority . findBadge) $ chunksOf 3 input
