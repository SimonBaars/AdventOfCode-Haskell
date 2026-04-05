module Day10 (part1, part2) where

import Data.List (intercalate)

expand :: String -> [Int]
expand = concatMap f . lines
  where
    f "noop" = [0]
    f s
      | take 4 s == "addx" = [0, read (drop 5 s)]
      | otherwise = error "Day10: bad instr"

xDuring :: [Int] -> [Int]
xDuring deltas = scanl (+) 1 deltas

signalSum :: [Int] -> Int
signalSum xs =
  sum
    [ c * x
      | (c, x) <- zip [1 ..] xs,
        c `elem` [20, 60, 100, 140, 180, 220]
    ]

part1 :: String -> Int
part1 = signalSum . xDuring . expand

render :: [Int] -> String
render xs =
  intercalate "\n"
    [ [ pixel (c - 1) x
        | c <- [40 * r + 1 .. 40 * r + 40],
          let x = xs !! (c - 1)
      ]
      | r <- [0 .. 5]
    ]
  where
    pixel cycle0 xv =
      let col = cycle0 `mod` 40
       in if abs (col - xv) <= 1 then '#' else '.'

part2 :: String -> String
part2 = render . xDuring . expand
