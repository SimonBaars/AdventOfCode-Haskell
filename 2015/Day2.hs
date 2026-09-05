import Data.List (sort)
import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [[Integer]]
input = map parse $ unsafePerformIO $ readInputLines 2015 2
  where parse line = map read $ words [if c=='x' then ' ' else c | c <- line]

paperSize :: [Integer] -> Integer
paperSize xs@[l,w,h] = 2*l*w + 2*w*h + 2*h*l + product (init (sort xs))
paperSize _ = 0

ribbonSize :: [Integer] -> Integer
ribbonSize xs = product xs + 2 * sum (init (sort xs))

part1 :: Integer
part1 = sum $ map paperSize input

part2 :: Integer
part2 = sum $ map ribbonSize input
