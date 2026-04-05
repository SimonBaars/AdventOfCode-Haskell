module Day01 (part1, part2) where

parse :: String -> [Int]
parse = map read . lines

part1 :: String -> Int
part1 s =
  let xs = parse s
   in length $ filter (uncurry (<)) $ zip xs (tail xs)

part2 :: String -> Int
part2 s =
  let xs = parse s
      sums = zipWith3 (\a b c -> a + b + c) xs (tail xs) (drop 2 xs)
   in length $ filter (uncurry (<)) $ zip sums (tail sums)
