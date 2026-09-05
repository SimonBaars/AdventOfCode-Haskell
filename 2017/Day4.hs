import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (nub, sort)

input :: [String]
input = unsafePerformIO $ readInputLines 2017 4

isValid1 :: String -> Bool
isValid1 phrase = length ws == length (nub ws)
  where ws = words phrase

isValid2 :: String -> Bool
isValid2 phrase = length ws == length (nub $ map sort ws)
  where ws = words phrase

part1 :: Int
part1 = length $ filter isValid1 input

part2 :: Int
part2 = length $ filter isValid2 input
