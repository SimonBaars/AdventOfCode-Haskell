import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (transpose, group, sort)

input :: [String]
input = unsafePerformIO $ readInputLines 2021 3

mostCommon :: String -> Char
mostCommon = head . head . reverse . sort . group . sort

leastCommon :: String -> Char
leastCommon = head . head . sort . group . sort

binaryToInt :: String -> Int
binaryToInt = foldl (\acc x -> acc * 2 + if x == '1' then 1 else 0) 0

part1 :: Int
part1 = gamma * epsilon
  where
    gamma = binaryToInt $ map mostCommon $ transpose input
    epsilon = binaryToInt $ map leastCommon $ transpose input

part2 :: Int
part2 = oxygen * co2
  where
    oxygen = binaryToInt $ filterByBit mostCommon 0 input
    co2 = binaryToInt $ filterByBit leastCommon 0 input
    filterByBit _ _ [x] = x
    filterByBit f pos nums = filterByBit f (pos + 1) filtered
      where
        bit = f [n !! pos | n <- nums]
        filtered = filter (\n -> n !! pos == bit) nums
