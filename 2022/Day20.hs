-- Day 20: Grove Positioning System
-- Circular list mixing
import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (elemIndex)
import Data.Maybe (fromJust)

input :: [Int]
input = unsafePerformIO $ do
    lines <- readInputLines 2022 20
    return $ map read lines

-- Mix the list once
mix :: [(Int, Int)] -> [(Int, Int)]
mix nums = foldl moveItem nums [0..length nums - 1]
  where
    moveItem lst origIdx = 
        let idx = fromJust $ elemIndex (origIdx, 0) [(i, v) | (i, v) <- lst]
            (i, val) = lst !! idx
            removed = take idx lst ++ drop (idx + 1) lst
            newIdx = (idx + val) `mod` length removed
        in take newIdx removed ++ [(i, val)] ++ drop newIdx removed

part1 :: Int
part1 = sum [vals !! ((zeroIdx + offset) `mod` len) | offset <- [1000, 2000, 3000]]
  where
    indexed = zip [0..] input
    mixed = mix indexed
    vals = map snd mixed
    zeroIdx = fromJust $ elemIndex 0 vals
    len = length vals

part2 :: Integer
part2 = toInteger $ sum [vals !! ((zeroIdx + offset) `mod` len) | offset <- [1000, 2000, 3000]]
  where
    key = 811589153
    indexed = zip [0..] $ map (*key) input
    mixed = iterate mix indexed !! 10
    vals = map snd mixed
    zeroIdx = fromJust $ elemIndex 0 vals
    len = length vals
