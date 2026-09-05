import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (isInfixOf, tails)

-- Day 5: Doesn't He Have Intern-Elves For This?
-- Determine which strings are "nice"

input :: [String]
input = unsafePerformIO $ readInputLines 2015 5

-- Part 1: Old rules for nice strings
isNice1 :: String -> Bool
isNice1 s = hasThreeVowels s && hasDoubleLetter s && not (hasForbiddenPair s)

hasThreeVowels :: String -> Bool
hasThreeVowels s = length (filter (`elem` "aeiou") s) >= 3

hasDoubleLetter :: String -> Bool
hasDoubleLetter s = any (\(a:b:_) -> a == b) (filter ((>= 2) . length) $ tails s)

hasForbiddenPair :: String -> Bool
hasForbiddenPair s = any (`isInfixOf` s) ["ab", "cd", "pq", "xy"]

part1 :: Int
part1 = length $ filter isNice1 input

-- Part 2: New rules for nice strings
isNice2 :: String -> Bool
isNice2 s = hasPairTwice s && hasRepeatWithGap s

hasPairTwice :: String -> Bool
hasPairTwice s = any (\i -> take 2 (drop i s) `isInfixOf` drop (i+2) s) [0..length s - 2]

hasRepeatWithGap :: String -> Bool
hasRepeatWithGap s = any (\(a:_:c:_) -> a == c) (filter ((>= 3) . length) $ tails s)

part2 :: Int
part2 = length $ filter isNice2 input
