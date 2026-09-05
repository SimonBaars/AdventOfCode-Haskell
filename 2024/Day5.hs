-- Day 5: Print Queue
-- Part 1: Sum middle pages of correctly ordered updates
-- Part 2: Fix incorrectly ordered updates and sum their middle pages

import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (sortBy)

input :: String
input = unsafePerformIO $ readInput 2024 5

type Rule = (Int, Int)
type Update = [Int]

parseInput :: String -> ([Rule], [Update])
parseInput str = (rules, updates)
  where
    [rulesStr, updatesStr] = splitOn "\n\n" str
    rules = [parseRule line | line <- lines rulesStr]
    updates = [map read $ splitOn "," line | line <- lines updatesStr]
    
    parseRule line = (read a, read b)
      where [a, b] = splitOn "|" line
    
    splitOn delim s = case breakOn delim s of
        (chunk, "") -> [chunk]
        (chunk, rest) -> chunk : splitOn delim (drop (length delim) rest)
    
    breakOn delim str' = go [] str'
      where
        go acc s
            | take (length delim) s == delim = (reverse acc, s)
            | null s = (reverse acc, "")
            | otherwise = go (head s : acc) (tail s)

isOrdered :: [Rule] -> Update -> Bool
isOrdered rules update = all checkRule rules
  where
    positions = zip update [0..]
    checkRule (x, y) = case (lookup x positions, lookup y positions) of
        (Just px, Just py) -> px < py
        _ -> True

middlePage :: Update -> Int
middlePage pages = pages !! (length pages `div` 2)

fixOrder :: [Rule] -> Update -> Update
fixOrder rules update = sortBy cmp update
  where
    cmp a b
        | (a, b) `elem` rules = LT
        | (b, a) `elem` rules = GT
        | otherwise = EQ

part1 :: Int
part1 = sum [middlePage u | u <- updates, isOrdered rules u]
  where
    (rules, updates) = parseInput input

part2 :: Int
part2 = sum [middlePage (fixOrder rules u) | u <- updates, not (isOrdered rules u)]
  where
    (rules, updates) = parseInput input
