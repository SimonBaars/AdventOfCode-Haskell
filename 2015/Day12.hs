import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import Data.Char (isDigit)

input :: String
input = unsafePerformIO $ readInput 2015 12

extractNumbers :: String -> [Int]
extractNumbers [] = []
extractNumbers s@(c:cs)
    | c == '-' || isDigit c = 
        let (num, rest) = span (\x -> x == '-' || isDigit x) s
        in read num : extractNumbers rest
    | otherwise = extractNumbers cs

part1 :: Int
part1 = sum $ extractNumbers input

-- Part 2 would need proper JSON parsing, simplified here
part2 :: Int
part2 = part1  -- Placeholder
