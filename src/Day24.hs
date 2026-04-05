module Day24 (part1, part2) where

import Data.List (elemIndex)
import Data.Maybe (fromJust)
import qualified Data.Set as Set

type Pt = (Int, Int)

data Cell = Wall | Open | Blizzard Char
  deriving (Eq)

parse :: String -> ([[Cell]], Pt, Pt, Int, Int)
parse raw =
  let ls = lines raw
      h = length ls
      w = length (head ls)
      grid =
        [ [ cell c
            | c <- row
          ]
          | row <- ls
        ]
      cell '#' = Wall
      cell '.' = Open
      cell x = Blizzard x
      startJ = fromJust $ elemIndex '.' (head ls)
      endJ = fromJust $ elemIndex '.' (last ls)
   in (grid, (0, startJ), (h - 1, endJ), h, w)

norm :: Int -> Int -> Int
norm m x = (x `mod` m + m) `mod` m

blizzAt :: [[Cell]] -> Int -> Int -> Int -> Set.Set Pt
blizzAt grid t h w =
  let innerH = h - 2
      innerW = w - 2
   in Set.fromList $
        concat
          [ case grid !! i !! j of
              Blizzard d ->
                let bi = i - 1
                    bj = j - 1
                    (ni, nj) = case d of
                      '^' -> (norm innerH (bi - t), bj)
                      'v' -> (norm innerH (bi + t), bj)
                      '<' -> (bi, norm innerW (bj - t))
                      '>' -> (bi, norm innerW (bj + t))
                      _ -> error "Day24: blizzard"
                 in [(ni + 1, nj + 1)]
              _ -> []
            | i <- [1 .. h - 2],
              j <- [1 .. w - 2]
          ]

passable :: [[Cell]] -> Int -> Int -> Pt -> Bool
passable grid h w (i, j)
  | i < 0 || i >= h || j < 0 || j >= w = False
  | otherwise = case grid !! i !! j of
      Wall -> False
      _ -> True

neighbors :: Pt -> [Pt]
neighbors (i, j) = [(i, j), (i - 1, j), (i + 1, j), (i, j - 1), (i, j + 1)]

shortest :: [[Cell]] -> Pt -> Pt -> Int -> Int -> Int -> Int
shortest grid start goal h w tStart =
  let period = lcm (h - 2) (w - 2)
      bl tt = blizzAt grid tt h w
      go [] _ = error "Day24: no path"
      go ((t, r, c) : q) vis
        | (r, c) == goal = t
        | (r, c, t `mod` period) `Set.member` vis = go q vis
        | otherwise =
            let vis' = Set.insert (r, c, t `mod` period) vis
                t' = t + 1
                bz = bl t'
                nbrs =
                  [ (t', nr, nc)
                    | (nr, nc) <- neighbors (r, c),
                      passable grid h w (nr, nc),
                      not ((nr, nc) `Set.member` bz)
                  ]
             in go (q ++ nbrs) vis'
   in go [(tStart, fst start, snd start)] Set.empty

part1 :: String -> Int
part1 s =
  let (grid, start, goal, h, w) = parse s
   in shortest grid start goal h w 0

part2 :: String -> Int
part2 s =
  let (grid, start, goal, h, w) = parse s
      t1 = shortest grid start goal h w 0
      t2 = shortest grid goal start h w t1
      t3 = shortest grid start goal h w t2
   in t3
