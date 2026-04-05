module Day20 (part1, part2) where

import Data.List (delete, elemIndex)
import Data.Maybe (fromJust)

parse :: String -> [Integer]
parse = map read . lines

key :: Integer
key = 811589153

tagged :: [Integer] -> [(Int, Integer)]
tagged xs = zip [0 ..] xs

moveOne :: [(Int, Integer)] -> Int -> [(Int, Integer)]
moveOne xs k =
  let elt@(i, v) = head $ filter ((== k) . fst) xs
      pos = fromJust $ elemIndex elt xs
      xs' = delete elt xs
      len = length xs'
      offset =
        if len == 0
          then 0
          else fromInteger ((v `mod` fromIntegral len + fromIntegral len) `mod` fromIntegral len)
      npos = (pos + offset) `mod` len
      (a, b) = splitAt npos xs'
   in a ++ [elt] ++ b

mixOnce :: [(Int, Integer)] -> [(Int, Integer)]
mixOnce xs = foldl moveOne xs [0 .. length xs - 1]

coordinates :: [(Int, Integer)] -> Integer
coordinates mixed =
  let vals = map snd mixed
      n = length vals
      i0 = fromJust $ elemIndex 0 vals
      a = vals !! ((i0 + 1000) `mod` n)
      b = vals !! ((i0 + 2000) `mod` n)
      c = vals !! ((i0 + 3000) `mod` n)
   in a + b + c

run :: Integer -> Int -> [Integer] -> Integer
run mult rounds nums =
  let xs = tagged $ map (* mult) nums
      mixed = iterate mixOnce xs !! rounds
   in coordinates mixed

part1 :: String -> Integer
part1 = run 1 1 . parse

part2 :: String -> Integer
part2 = run key 10 . parse
