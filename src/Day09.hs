module Day09 (part1, part2) where

import Data.List (nub)

type Pos = (Int, Int)

parseDir :: String -> (Int, Int)
parseDir "R" = (1, 0)
parseDir "L" = (-1, 0)
parseDir "U" = (0, 1)
parseDir "D" = (0, -1)
parseDir _ = error "Day09: bad dir"

parseLine :: String -> [(Int, Int)]
parseLine s =
  case words s of
    [d, n] -> replicate (read n) (parseDir d)
    _ -> error "Day09: bad line"

stepKnot :: Pos -> Pos -> Pos
stepKnot (hx, hy) (tx, ty)
  | abs (hx - tx) <= 1 && abs (hy - ty) <= 1 = (tx, ty)
  | otherwise = (tx + signum (hx - tx), ty + signum (hy - ty))

simulate :: [Pos] -> [(Int, Int)] -> [[Pos]]
simulate start moves = scanl go start moves
  where
    go :: [Pos] -> (Int, Int) -> [Pos]
    go rope (dx, dy) =
      let (hx, hy) = head rope
          h' = (hx + dx, hy + dy)
          rest = scanl stepKnot h' (tail rope)
       in h' : tail rest

trail :: Int -> String -> [Pos]
trail n s =
  let moves = concatMap parseLine $ lines s
      start = replicate n (0, 0)
   in map last $ tail $ simulate start moves

part1 :: String -> Int
part1 = length . nub . trail 2

part2 :: String -> Int
part2 = length . nub . trail 10
