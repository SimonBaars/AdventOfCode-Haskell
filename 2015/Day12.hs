import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import Data.Char (isDigit)
import Data.List (isInfixOf)

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

-- Part 2: Exclude objects containing "red" as a value
part2 :: Int
part2 = sumWithoutRed input

sumWithoutRed :: String -> Int
sumWithoutRed s = sumJSON s 0
  where
    sumJSON [] n = n
    sumJSON ('{':rest) n = 
        let (obj, after) = extractBraced rest '}' 1
        in if ":\"red\"" `isInfixOf` obj
           then sumJSON after n
           else sumJSON (obj ++ after) n
    sumJSON ('[':rest) n = 
        let (arr, after) = extractBraced rest ']' 1
        in sumJSON (arr ++ after) n
    sumJSON (c:rest) n
        | c == '-' || isDigit c =
            let (num, after) = span (\x -> x == '-' || isDigit x) (c:rest)
            in sumJSON after (n + read num)
        | otherwise = sumJSON rest n
    
    extractBraced [] _ _ = ([], [])
    extractBraced (c:cs) closing depth
        | c == closing && depth == 1 = ([], cs)
        | c == closing = let (rest, after) = extractBraced cs closing (depth - 1) in (c:rest, after)
        | c == '{' || c == '[' = let (rest, after) = extractBraced cs closing (depth + 1) in (c:rest, after)
        | otherwise = let (rest, after) = extractBraced cs closing depth in (c:rest, after)
