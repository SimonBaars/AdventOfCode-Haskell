module Day08 (part1, part2) where

import Data.Array.Unboxed (UArray)
import qualified Data.Array.Unboxed as A

parse :: String -> UArray (Int, Int) Int
parse s =
  let ls = lines s
      h = length ls
      w = length (head ls)
      g = A.listArray ((0, 0), (h - 1, w - 1)) [ read [c] | row <- ls, c <- row ]
   in g

visible :: UArray (Int, Int) Int -> Int
visible g =
  sum
    [ 1
      | i <- [0 .. h - 1],
        j <- [0 .. w - 1],
        let x = g A.! (i, j),
        or
          [ all (\(ii, jj) -> g A.! (ii, jj) < x) [(i, jj) | jj <- [0 .. j - 1]],
            all (\(ii, jj) -> g A.! (ii, jj) < x) [(i, jj) | jj <- [j + 1 .. w - 1]],
            all (\(ii, jj) -> g A.! (ii, jj) < x) [(ii, j) | ii <- [0 .. i - 1]],
            all (\(ii, jj) -> g A.! (ii, jj) < x) [(ii, j) | ii <- [i + 1 .. h - 1]]
          ]
    ]
  where
    ((_, _), (hm, wm)) = A.bounds g
    h = hm + 1
    w = wm + 1

scenic :: UArray (Int, Int) Int -> Int
scenic g = maximum [score i j | i <- [0 .. h - 1], j <- [0 .. w - 1]]
  where
    ((_, _), (hm, wm)) = A.bounds g
    h = hm + 1
    w = wm + 1
    get = (A.!) g
    score i j =
      let v = get (i, j)
          left = count v [(i, jj) | jj <- [j - 1, j - 2 .. 0]]
          right = count v [(i, jj) | jj <- [j + 1 .. w - 1]]
          up = count v [(ii, j) | ii <- [i - 1, i - 2 .. 0]]
          down = count v [(ii, j) | ii <- [i + 1 .. h - 1]]
       in left * right * up * down
    count v coords = go 0 coords
      where
        go !n [] = n
        go !n (c : cs)
          | get c >= v = n + 1
          | otherwise = go (n + 1) cs

part1 :: String -> Int
part1 = visible . parse

part2 :: String -> Int
part2 = scenic . parse
