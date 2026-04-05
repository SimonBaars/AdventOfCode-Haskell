module Day06 (part1, part2) where

import qualified Data.Set as Set

marker :: Int -> String -> Int
marker n s = go 0
  where
    go i
      | i + n > length s = error "Day06: no marker"
      | Set.size (Set.fromList chunk) == n = i + n
      | otherwise = go (i + 1)
      where
        chunk = take n $ drop i s

part1 :: String -> Int
part1 = marker 4 . head . lines

part2 :: String -> Int
part2 = marker 14 . head . lines
