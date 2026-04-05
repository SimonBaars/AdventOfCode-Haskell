module Day22 (part1, part2) where

import Data.Array.Unboxed (UArray, (!), bounds)
import qualified Data.Array.Unboxed as A

type Grid = UArray (Int, Int) Char

parse :: String -> (Grid, String)
parse raw =
  let ls = lines raw
      (gridLines, rest) = break (== "") ls
      moves = filter (`elem` "0123456789LR") $ concat $ drop 1 rest
      h = length gridLines
      w = maximum $ map length gridLines
      pad r = r ++ replicate (w - length r) ' '
      rows = map pad gridLines
      g = A.listArray ((0, 0), (h - 1, w - 1)) [c | row <- rows, c <- row]
   in (g, moves)

-- Match AoC: 0=right, 1=down, 2=left, 3=up
delta :: Int -> (Int, Int)
delta 0 = (0, 1)
delta 1 = (1, 0)
delta 2 = (0, -1)
delta 3 = (-1, 0)
delta _ = error "Day22: dir"

password :: Int -> Int -> Int -> Int
password r c d = 1000 * (r + 1) + 4 * (c + 1) + d

startCol :: Grid -> Int
startCol g =
  let (_, (_, w)) = bounds g
   in head [c | c <- [0 .. w], g ! (0, c) == '.']

wrapFlat :: Grid -> Int -> Int -> Int -> (Int, Int)
wrapFlat g r c d =
  let (_, (h, w)) = bounds g
   in case d of
        0 -> (r, minimum [j | j <- [0 .. w], g ! (r, j) /= ' '])
        2 -> (r, maximum [j | j <- [0 .. w], g ! (r, j) /= ' '])
        1 -> (minimum [i | i <- [0 .. h], g ! (i, c) /= ' '], c)
        3 -> (maximum [i | i <- [0 .. h], g ! (i, c) /= ' '], c)
        _ -> error "Day22: wrapFlat"

-- Rust reference uses dir 0=left,1=down,2=right,3=up for the folding table.
toRust :: Int -> Int
toRust d = (d + 3) `mod` 4

fromRust :: Int -> Int
fromRust rd = (rd + 1) `mod` 4

wrapCube :: Int -> Int -> Int -> (Int, Int, Int)
wrapCube r c d =
  let rd = toRust d
      qr = r `div` 50
      qc = c `div` 50
      dr = r `mod` 50
      dc = c `mod` 50
      i = [dc, dr, 49 - dc, 49 - dr] !! rd
      (qr', qc', ndRust) = case (qr, qc, rd) of
        (0, 1, 0) -> (3, 0, 1)
        (0, 1, 3) -> (2, 0, 1)
        (0, 2, 0) -> (3, 0, 0)
        (0, 2, 1) -> (2, 1, 3)
        (0, 2, 2) -> (1, 1, 3)
        (1, 1, 1) -> (0, 2, 0)
        (1, 1, 3) -> (2, 0, 2)
        (2, 0, 0) -> (1, 1, 1)
        (2, 0, 3) -> (0, 1, 1)
        (2, 1, 1) -> (0, 2, 3)
        (2, 1, 2) -> (3, 0, 3)
        (3, 0, 1) -> (2, 1, 0)
        (3, 0, 2) -> (0, 2, 2)
        (3, 0, 3) -> (0, 1, 2)
        _ -> error $ "Day22: bad cube wrap " ++ show (qr, qc, rd)
      (nr, nc) = case ndRust of
        0 -> (49, i)
        1 -> (i, 0)
        2 -> (0, 49 - i)
        3 -> (49 - i, 49)
        _ -> error "Day22: nd"
      nd = fromRust ndRust
   in (qr' * 50 + nr, qc' * 50 + nc, nd)

step :: Bool -> Grid -> Int -> Int -> Int -> (Int, Int, Int)
step cube g r c d =
  let (dr, dc) = delta d
      (_, (h, w)) = bounds g
      nr = r + dr
      nc = c + dc
   in if nr >= 0 && nr <= h && nc >= 0 && nc <= w && g ! (nr, nc) /= ' '
        then (nr, nc, d)
        else
          if cube
            then wrapCube r c d
            else
              let (wr, wc) = wrapFlat g r c d
               in (wr, wc, d)

walk :: Bool -> Grid -> String -> Int
walk cube g moves = exec (0, startCol g, 0) moves :: Int
  where
    exec (r, c, d) [] = password r c d
    exec (r, c, d) ('L' : ms) = exec (r, c, (d + 3) `mod` 4) ms
    exec (r, c, d) ('R' : ms) = exec (r, c, (d + 1) `mod` 4) ms
    exec pos (x : ms)
      | x `elem` ['0' .. '9'] =
          let (nStr, rest) = span (`elem` ['0' .. '9']) (x : ms)
              n = read nStr
           in walkN n pos rest
      | otherwise = exec pos ms
    walkN 0 pos rest = exec pos rest
    walkN k (r, c, d) rest =
      let (nr, nc, nd) = step cube g r c d
       in if g ! (nr, nc) == '#'
            then exec (r, c, d) rest
            else walkN (k - 1) (nr, nc, nd) rest

part1 :: String -> Int
part1 s = let (g, moves) = parse s in walk False g moves

part2 :: String -> Int
part2 s = let (g, moves) = parse s in walk True g moves
