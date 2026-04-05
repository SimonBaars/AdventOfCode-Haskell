module Day23 (part1, part2) where

import qualified Data.Map as Map
import qualified Data.Set as Set

type Pt = (Int, Int)

parse :: String -> Set.Set Pt
parse = Set.fromList . concat . zipWith row [0 ..] . lines
  where
    row i l = [(i, j) | (j, c) <- zip [0 ..] l, c == '#']

neighbors8 :: Pt -> [Pt]
neighbors8 (i, j) =
  [ (i + di, j + dj)
    | di <- [-1 .. 1],
      dj <- [-1 .. 1],
      not (di == 0 && dj == 0)
  ]

hasNeighbor :: Set.Set Pt -> Pt -> Bool
hasNeighbor s e = any (`Set.member` s) $ neighbors8 e

dirs :: Pt -> [(Pt, [Pt])]
dirs (i, j) =
  let n = (i - 1, j)
      s = (i + 1, j)
      w = (i, j - 1)
      e = (i, j + 1)
      nw = (i - 1, j - 1)
      ne = (i - 1, j + 1)
      sw = (i + 1, j - 1)
      se = (i + 1, j + 1)
   in [ (n, [n, nw, ne]),
        (s, [s, sw, se]),
        (w, [w, nw, sw]),
        (e, [e, ne, se])
      ]

propose :: Int -> Set.Set Pt -> Pt -> Maybe Pt
propose r s e
  | not (hasNeighbor s e) = Nothing
  | otherwise =
      let ord = take 4 $ drop (r `mod` 4) $ cycle $ dirs e
          clear block = all (not . (`Set.member` s)) block
       in case [d | (d, block) <- ord, clear block] of
            (x : _) -> Just x
            [] -> Nothing

roundStep :: Int -> Set.Set Pt -> Set.Set Pt
roundStep r s =
  let elves = Set.toList s
      prop e = propose r s e
      byDest =
        Map.fromListWith (++) [(d, [e]) | e <- elves, Just d <- [prop e]]
      final e =
        case prop e of
          Nothing -> e
          Just d
            | length (Map.findWithDefault [] d byDest) == 1 -> d
            | otherwise -> e
   in Set.fromList $ map final elves

emptyRect :: Set.Set Pt -> Int
emptyRect s
  | Set.null s = 0
  | otherwise =
      let is = Set.map fst s
          js = Set.map snd s
          imin = Set.findMin is
          imax = Set.findMax is
          jmin = Set.findMin js
          jmax = Set.findMax js
          area = (imax - imin + 1) * (jmax - jmin + 1)
       in area - Set.size s

part1 :: String -> Int
part1 raw =
  let s0 = parse raw
      s10 = foldl (\s r -> roundStep r s) s0 [0 .. 9]
   in emptyRect s10

part2 :: String -> Int
part2 raw =
  let s0 = parse raw
      go !r !s =
        let s' = roundStep r s
         in if s' == s then r + 1 else go (r + 1) s'
   in go 0 s0
