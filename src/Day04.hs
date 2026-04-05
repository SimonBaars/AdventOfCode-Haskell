module Day04 (part1, part2) where

import Data.List.Split (splitOn)

parseRange :: String -> (Int, Int)
parseRange s =
  case splitOn "-" s of
    [a, b] -> (read a, read b)
    _ -> error "Day04: bad range"

parseLine :: String -> ((Int, Int), (Int, Int))
parseLine l =
  case splitOn "," l of
    [a, b] -> (parseRange a, parseRange b)
    _ -> error "Day04: bad line"

contains :: (Int, Int) -> (Int, Int) -> Bool
contains (a, b) (c, d) = a <= c && d <= b

overlap :: (Int, Int) -> (Int, Int) -> Bool
overlap (a, b) (c, d) = not (b < c || d < a)

part1 :: String -> Int
part1 =
  length
    . filter (\(x, y) -> contains x y || contains y x)
    . map parseLine
    . lines

part2 :: String -> Int
part2 =
  length
    . filter (uncurry overlap)
    . map parseLine
    . lines
