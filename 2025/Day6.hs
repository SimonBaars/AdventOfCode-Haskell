-- Day 6: Trash Compactor
-- Part 1: Sum of all problem solutions
-- Part 2: TBD

import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import Data.Char (isDigit)
import Data.List (transpose)

input :: String
input = unsafePerformIO $ readInput 2025 6

-- Parse vertical problems
parseProblems :: String -> [[Integer]]
parseProblems str = [parseColumn col | col <- columns, not (null $ filter isDigit col)]
  where
    lines' = lines str
    columns = transpose lines'
    
    parseColumn col = [read num :: Integer | num <- extractNumbers col, not (null num)]
    
    extractNumbers [] = []
    extractNumbers s
        | null digits = extractNumbers rest
        | otherwise = digits : extractNumbers rest
      where
        (digits, afterDigits) = span isDigit s
        rest = dropWhile (not . isDigit) afterDigits

-- Solve a problem
solveProblem :: [Integer] -> Integer
solveProblem nums
    | last str == '+' = sum (init nums)
    | last str == '*' = product (init nums)
  where
    str = show (head nums)

part1 :: Integer
part1 = sum [solveProblem problem | problem <- parseProblems input]

part2 :: Integer
part2 = 0  -- TBD
