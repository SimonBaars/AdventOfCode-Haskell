module Day14 (part1, part2) where

import Data.List.Split (splitOn)
import qualified Data.Set as Set

type Pt = (Int, Int)

parse :: String -> (Set.Set Pt, Int)
parse s =
  let segs = lines s
      pts = concatMap parseSeg segs
      maxY = maximum $ 0 : map snd (Set.toList $ Set.fromList pts)
   in (Set.fromList pts, maxY)

parseSeg :: String -> [Pt]
parseSeg l =
  let parts = map parsePt $ splitOn " -> " l
   in concat $ zipWith line parts (tail parts)

parsePt :: String -> Pt
parsePt s =
  case break (== ',') s of
    (a, _ : b) -> (read a, read b)
    _ -> error "Day14: pt"

line :: Pt -> Pt -> [Pt]
line (x1, y1) (x2, y2)
  | x1 == x2 = [(x1, y) | y <- range y1 y2]
  | y1 == y2 = [(x, y1) | x <- range x1 x2]
  | otherwise = error "Day14: diagonal"
  where
    range a b = if a <= b then [a .. b] else [a, a - 1 .. b]

dropSand :: Int -> Set.Set Pt -> Maybe Pt
dropSand maxY rocks = go (500, 0)
  where
    go (x, y)
      | y > maxY = Nothing
      | otherwise =
          let down = (x, y + 1)
              dl = (x - 1, y + 1)
              dr = (x + 1, y + 1)
           in if not (down `Set.member` rocks)
                then go down
                else
                  if not (dl `Set.member` rocks)
                    then go dl
                    else
                      if not (dr `Set.member` rocks)
                        then go dr
                        else Just (x, y)

floorPts :: Int -> Int -> Int -> Set.Set Pt
floorPts minX maxX floorY = Set.fromList [(x, floorY) | x <- [minX .. maxX]]

part1 :: String -> Int
part1 s =
  let (rocks, maxY) = parse s
      loop !n !r =
        case dropSand maxY r of
          Nothing -> n
          Just p -> loop (n + 1) (Set.insert p r)
   in loop 0 rocks

part2 :: String -> Int
part2 s =
  let (rocks0, maxY) = parse s
      floorY = maxY + 2
      xs = map fst $ Set.toList rocks0
      spread = maxY + 10
      minX = min (minimum xs - spread) (500 - spread)
      maxX = max (maximum xs + spread) (500 + spread)
      rocks = rocks0 `Set.union` floorPts minX maxX floorY
      loop !n !r =
        case dropSand maxBound r of
          Nothing -> error "Day14: abyss with floor"
          Just p ->
            let r' = Set.insert p r
             in if p == (500, 0) then n + 1 else loop (n + 1) r'
   in loop 0 rocks
