-- Day 1: Trebuchet?!
-- Part 1: Extract first and last digits from each line
-- Part 2: Include spelled-out numbers (one, two, three, etc.)

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.Char (isDigit, digitToInt)
import Data.List (isPrefixOf)

input :: [String]
input = unsafePerformIO $ readInputLines 2023 1

extractDigits :: String -> [Int]
extractDigits = map digitToInt . filter isDigit

calibrationValue :: [Int] -> Int
calibrationValue digits = head digits * 10 + last digits

-- Convert spelled numbers to digits
convertSpelled :: String -> String
convertSpelled [] = []
convertSpelled s@(c:cs)
    | "one" `isPrefixOf` s = '1' : convertSpelled (tail s)
    | "two" `isPrefixOf` s = '2' : convertSpelled (tail s)
    | "three" `isPrefixOf` s = '3' : convertSpelled (tail s)
    | "four" `isPrefixOf` s = '4' : convertSpelled (tail s)
    | "five" `isPrefixOf` s = '5' : convertSpelled (tail s)
    | "six" `isPrefixOf` s = '6' : convertSpelled (tail s)
    | "seven" `isPrefixOf` s = '7' : convertSpelled (tail s)
    | "eight" `isPrefixOf` s = '8' : convertSpelled (tail s)
    | "nine" `isPrefixOf` s = '9' : convertSpelled (tail s)
    | otherwise = c : convertSpelled cs

part1 :: Int
part1 = sum $ map (calibrationValue . extractDigits) input

part2 :: Int
part2 = sum $ map (calibrationValue . extractDigits . convertSpelled) input
