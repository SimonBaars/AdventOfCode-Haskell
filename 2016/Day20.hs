import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (sort)

input :: [String]
input = unsafePerformIO $ readInputLines 2016 20

parseRange :: String -> (Int, Int)
parseRange str = (read low, read high)
  where (low, rest) = break (== '-') str
        high = tail rest

mergeRanges :: [(Int, Int)] -> [(Int, Int)]
mergeRanges [] = []
mergeRanges [x] = [x]
mergeRanges ((a1, b1):(a2, b2):rest)
    | b1 >= a2 - 1 = mergeRanges ((a1, max b1 b2) : rest)
    | otherwise = (a1, b1) : mergeRanges ((a2, b2) : rest)

findFirstAllowed :: [(Int, Int)] -> Int
findFirstAllowed ((0, b):rest) = b + 1
findFirstAllowed _ = 0

countAllowed :: [(Int, Int)] -> Int -> Int
countAllowed ranges maxIP = maxIP + 1 - sum [b - a + 1 | (a, b) <- ranges]

ranges :: [(Int, Int)]
ranges = mergeRanges $ sort $ map parseRange input

part1 :: Int
part1 = findFirstAllowed ranges

part2 :: Int
part2 = countAllowed ranges 4294967295
