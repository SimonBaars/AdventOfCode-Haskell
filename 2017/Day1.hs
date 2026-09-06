import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import Data.Char (digitToInt)

input :: String
input = unsafePerformIO $ readInput 2017 1

digits :: [Int]
digits = map digitToInt $ filter (/= '\n') input

sumMatching :: Int -> [Int] -> Int
sumMatching offset ds = sum [d | (i, d) <- zip [0..] ds, ds !! ((i + offset) `mod` length ds) == d]

part1 :: Int
part1 = sumMatching 1 digits

part2 :: Int
part2 = sumMatching (length digits `div` 2) digits
