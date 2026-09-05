-- Day 11: Plutonian Pebbles
-- Part 1: Count stones after 25 blinks
-- Part 2: Count stones after 75 blinks (memoization)

import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Map as M

input :: [Integer]
input = unsafePerformIO $ map read . words <$> readInput 2024 11

-- Apply blink rules to a single stone
blink :: Integer -> [Integer]
blink 0 = [1]
blink n
    | even (length digits) = [read (take half digits), read (drop half digits)]
    | otherwise = [n * 2024]
  where
    digits = show n
    half = length digits `div` 2

-- Count stones after n blinks using memoization
countStones :: Int -> [Integer] -> Integer
countStones blinks stones = sum [go M.empty stone blinks | stone <- stones]
  where
    go memo stone 0 = 1
    go memo stone n
        | M.member (stone, n) memo = memo M.! (stone, n)
        | otherwise = result
      where
        nextStones = blink stone
        result = sum [go newMemo s (n - 1) | s <- nextStones]
        newMemo = M.insert (stone, n) result memo

part1 :: Integer
part1 = countStones 25 input

part2 :: Integer
part2 = countStones 75 input
