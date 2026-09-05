{-# LANGUAGE BangPatterns #-}
import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import Data.Char (isDigit)

input :: String
input = unsafePerformIO $ readInput 2015 25

row, col :: Int
(row, col) =
  let nums = map read $ words $ map (\c -> if isDigit c then c else ' ') input :: [Int]
  in (nums!!0, nums!!1)

position :: Int -> Int -> Int
position r c = let d = r + c - 1 in d*(d-1) `div` 2 + c

codeAt :: Int -> Integer
codeAt pos = go 20151125 1
  where
    go !code !i
      | i == pos = code
      | otherwise = go ((code * 252533) `mod` 33554393) (i+1)

part1 :: Integer
part1 = codeAt (position row col)

part2 :: Integer
part2 = 0
