module Day17 (part1, part2) where

import qualified Data.Map as Map
import qualified Data.Set as Set

type Pt = (Int, Int)

shapes :: [[Pt]]
shapes =
  [ [(0, 0), (1, 0), (2, 0), (3, 0)],
    [(1, 0), (0, 1), (1, 1), (2, 1), (1, 2)],
    [(0, 0), (1, 0), (2, 0), (2, 1), (2, 2)],
    [(0, 0), (0, 1), (0, 2), (0, 3)],
    [(0, 0), (1, 0), (0, 1), (1, 1)]
  ]

width :: Int
width = 7

tryMove :: Set.Set Pt -> [Pt] -> Int -> Int -> Maybe [Pt]
tryMove occ shape dx dy =
  let moved = [(x + dx, y + dy) | (x, y) <- shape]
   in if all (\(x, y) -> x >= 0 && x < width && y >= 0 && not ((x, y) `Set.member` occ)) moved
        then Just moved
        else Nothing

fallRock :: String -> Int -> Set.Set Pt -> [Pt] -> (Set.Set Pt, Int)
fallRock jets ji occ shapePos = go ji shapePos
  where
    jl = length jets
    go ji' pos =
      let j = if jets !! (ji' `mod` jl) == '<' then -1 else 1
          ji'' = ji' + 1
          afterPush = case tryMove occ pos j 0 of
            Nothing -> pos
            Just p -> p
       in case tryMove occ afterPush 0 (-1) of
            Nothing -> (Set.union occ $ Set.fromList afterPush, ji'')
            Just p -> go ji'' p

towerHeight :: Set.Set Pt -> Int
towerHeight occ
  | Set.null occ = 0
  | otherwise = maximum (map snd $ Set.toList occ) + 1

colHeights :: Set.Set Pt -> [Int]
colHeights occ =
  [ if null ys then 0 else maximum ys
    | x <- [0 .. width - 1],
      let ys = [y | (x', y) <- Set.toList occ, x' == x]
  ]

normProfile :: Set.Set Pt -> [Int]
normProfile occ
  | Set.null occ = replicate width 0
  | otherwise =
      let hs = colHeights occ
          m = minimum hs
       in map (\h -> h - m) hs

simulateStep :: String -> Int -> Set.Set Pt -> Int -> (Set.Set Pt, Int)
simulateStep jets ji occ ri =
  let shape = shapes !! ri
      maxY = if Set.null occ then -1 else maximum (map snd $ Set.toList occ)
      baseY = maxY + 4
      start = [(x + 2, y + baseY) | (x, y) <- shape]
   in fallRock jets ji occ start

part1 :: String -> Int
part1 s =
  let jets = filter (`elem` "<>") $ concat $ lines s
      go :: Int -> Int -> Set.Set Pt -> Int -> Int
      go !i !ji !occ !ri
        | i >= 2022 = towerHeight occ
        | otherwise =
            let (occ', ji') = simulateStep jets ji occ ri
             in go (i + 1) ji' occ' ((ri + 1) `mod` 5)
   in go 0 0 Set.empty 0

part2 :: String -> Int
part2 s =
  let jets = filter (`elem` "<>") $ concat $ lines s
      target = 1000000000000
      (i0, h0, clen, dh) = findCycle jets
      cycles = (target - i0) `div` clen
      remRocks = (target - i0) `mod` clen
      hRem = heightAfterN jets (i0 + remRocks) - h0
   in h0 + cycles * dh + hRem

heightAfterN :: String -> Int -> Int
heightAfterN jets n = go 0 0 Set.empty 0
  where
    go :: Int -> Int -> Set.Set Pt -> Int -> Int
    go !i !ji !occ !ri
      | i >= n = towerHeight occ
      | otherwise =
          let (occ', ji') = simulateStep jets ji occ ri
           in go (i + 1) ji' occ' ((ri + 1) `mod` 5)

findCycle :: String -> (Int, Int, Int, Int)
findCycle jets = go 0 0 Set.empty 0 Map.empty
  where
    go !i !ji !occ !ri !seen =
      let key = (ji `mod` length jets, ri, normProfile occ)
       in case Map.lookup key seen of
            Just (i0, h0) ->
              let h = towerHeight occ
               in (i0, h0, i - i0, h - h0)
            Nothing ->
              let h = towerHeight occ
                  seen' = Map.insert key (i, h) seen
                  (occ', ji') = simulateStep jets ji occ ri
               in go (i + 1) ji' occ' ((ri + 1) `mod` 5) seen'
