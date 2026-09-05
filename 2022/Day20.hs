-- Day 20: Grove Positioning System
import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (elemIndex, findIndex)
import Data.Maybe (fromJust)

input :: [Integer]
input = unsafePerformIO $ map read <$> readInputLines 2022 20

mix :: [Integer] -> Int -> [Integer]
mix values times =
  let n = length values
      go order i =
        let pos = fromJust $ findIndex (== i) order
            order' = take pos order ++ drop (pos + 1) order
            val = values !! i
            newPos = fromIntegral $ (fromIntegral pos + val) `mod` fromIntegral (n - 1)
        in take newPos order' ++ [i] ++ drop newPos order'
      finalOrder = foldl (\ord _ -> foldl go ord [0 .. n - 1]) [0 .. n - 1] [1 .. times]
  in map (values !!) finalOrder

grove :: [Integer] -> Integer
grove mixed =
  let z = fromJust $ elemIndex 0 mixed
      len = length mixed
  in sum [mixed !! ((z + o) `mod` len) | o <- [1000, 2000, 3000]]

part1 :: Integer
part1 = grove $ mix input 1

part2 :: Integer
part2 = grove $ mix (map (* 811589153) input) 10
