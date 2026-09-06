-- Day 1: Calorie Counting
-- Part 1: Find the Elf carrying the most Calories
-- Part 2: Find the total Calories carried by the top three Elves

import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (sortBy)
import Data.Ord (Down(..))

input :: String
input = unsafePerformIO $ readInput 2022 1

-- Parse input into groups of calorie counts
parseGroups :: String -> [[Integer]]
parseGroups = map (map read . lines) . splitOn "\n\n"
  where
    splitOn :: String -> String -> [String]
    splitOn delim str = case breakOn delim str of
      (chunk, "") -> [chunk]
      (chunk, rest) -> chunk : splitOn delim (drop (length delim) rest)
    
    breakOn :: String -> String -> (String, String)
    breakOn delim str = go [] str
      where
        go acc s
          | take (length delim) s == delim = (reverse acc, s)
          | null s = (reverse acc, "")
          | otherwise = go (head s : acc) (tail s)

-- Calculate total calories per elf
elfTotals :: [[Integer]] -> [Integer]
elfTotals = map sum

part1 :: Integer
part1 = maximum $ elfTotals $ parseGroups input

part2 :: Integer
part2 = sum $ take 3 $ sortBy (flip compare) $ elfTotals $ parseGroups input
