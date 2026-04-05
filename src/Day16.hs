module Day16 (part1, part2) where

import Data.Bits
import qualified Data.Map as Map
import qualified Data.Set as Set

type Valve = String

data VInfo = VInfo Int [String]

parseLine :: String -> (Valve, VInfo)
parseLine s =
  case words s of
    ("Valve" : name : "has" : "flow" : "rate=" : r : _ : _ : _ : _ : ts) ->
      let r' = read $ takeWhile (`elem` ('-' : ['0' .. '9'])) r
          targets = splitTargets (unwords ts)
       in (name, VInfo r' targets)
    _ -> error "Day16: line"

splitTargets :: String -> [String]
splitTargets = map (filter (`elem` ['A' .. 'Z'])) . splitOnComma

splitOnComma :: String -> [String]
splitOnComma [] = []
splitOnComma s =
  case break (== ',') s of
    (a, _ : b) -> trim a : splitOnComma b
    (a, []) -> [trim a]
  where
    trim = reverse . dropWhile (== ' ') . reverse . dropWhile (== ' ')

bfsDist :: Map.Map Valve VInfo -> Valve -> Map.Map Valve Int
bfsDist g start = go (Set.singleton start) (Map.singleton start 0) [start]
  where
    go _seen dist [] = dist
    go seen dist (x : xs) =
      let d = dist Map.! x
          nbrs = case g Map.! x of VInfo _ ns -> ns
          foldNbr (sv, dv, q) n =
            if Set.member n sv
              then (sv, dv, q)
              else (Set.insert n sv, Map.insert n (d + 1) dv, q ++ [n])
          (seen', dist', extra) = foldl foldNbr (seen, dist, []) nbrs
       in go seen' dist' (xs ++ extra)

allDists :: Map.Map Valve VInfo -> Map.Map (Valve, Valve) Int
allDists g =
  Map.fromList
    [ ((a, b), d)
      | a <- Map.keys g,
        (b, d) <- Map.toList $ bfsDist g a
    ]

interesting :: Map.Map Valve VInfo -> [(Valve, Int)]
interesting g = [(n, r) | (n, VInfo r _) <- Map.toList g, r > 0]

type Memo = Map.Map (Valve, Int, Int) Int

dfs :: Map.Map Valve VInfo -> Map.Map (Valve, Valve) Int -> [Valve] -> [Int] -> Memo -> Valve -> Int -> Int -> (Int, Memo)
dfs g dists names rates memo0 pos t mask
  | t <= 0 = (0, memo0)
  | otherwise =
      let key = (pos, t, mask)
       in case Map.lookup key memo0 of
            Just v -> (v, memo0)
            Nothing ->
              let n = length names
                  tryOpen (!best, !m) i
                    | mask .&. bit i /= 0 = (best, m)
                    | otherwise =
                        let v = names !! i
                            d = Map.findWithDefault 999 (pos, v) dists
                            t' = t - d - 1
                         in if t' <= 0
                              then (best, m)
                              else
                                let gain = (rates !! i) * t'
                                    (sub, m') = dfs g dists names rates m v t' (mask .|. bit i)
                                    cand = gain + sub
                                 in (max best cand, m')
                  (best1, m1) = foldl tryOpen (0, memo0) [0 .. n - 1]
                  result = best1
                  m2 = Map.insert key result m1
               in (result, m2)

maxPressure :: Int -> Map.Map Valve VInfo -> Int
maxPressure maxT g =
  let ints = interesting g
      names = map fst ints
      rates = map snd ints
      dists = allDists g
      (v, _) = dfs g dists names rates Map.empty "AA" maxT 0
   in v

part1 :: String -> Int
part1 s =
  let g = Map.fromList $ map parseLine $ lines s
   in maxPressure 30 g

-- Part 2: two disjoint tours; enumerate subset for elephant using cached single-agent values
part2 :: String -> Int
part2 s =
  let g = Map.fromList $ map parseLine $ lines s
      ints = interesting g
      names = map fst ints
      rates = map snd ints
      dists = allDists g
      n = length names
      fullMask = (1 `shiftL` n) - 1
      run mask =
        fst $ dfs g dists names rates Map.empty "AA" 26 mask
      table = Map.fromList [(m, run m) | m <- [0 .. fullMask]]
      combine m1 =
        let m2 = fullMask `xor` m1
         in Map.findWithDefault 0 m1 table + Map.findWithDefault 0 m2 table
   in maximum $ map combine [0 .. fullMask]
