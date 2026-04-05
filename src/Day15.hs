module Day15 (part1, part2) where

import Data.List (nub, sort)
import Data.List.Split (splitOn)

type Pt = (Int, Int)

readCoord :: String -> Int
readCoord t = read $ last $ splitOn "=" t

parseCoordPair :: String -> Pt
parseCoordPair s =
  case splitOn ", " s of
    [a, b] -> (readCoord a, readCoord b)
    _ -> error "Day15: coord pair"

parseLine :: String -> (Pt, Pt, Int)
parseLine s =
  case splitOn ": closest beacon is at " s of
    [left, right] ->
      let sensStr = drop (length "Sensor at ") left
          sens = parseCoordPair sensStr
          beac = parseCoordPair right
          d = manhattan sens beac
       in (sens, beac, d)
    _ -> error "Day15: line"

manhattan :: Pt -> Pt -> Int
manhattan (x1, y1) (x2, y2) = abs (x1 - x2) + abs (y1 - y2)

intervalRow :: Int -> Pt -> Int -> Maybe (Int, Int)
intervalRow y (sx, sy) d =
  let dy = abs (y - sy)
      r = d - dy
   in if r < 0 then Nothing else Just (sx - r, sx + r)

mergeIntervals :: [(Int, Int)] -> [(Int, Int)]
mergeIntervals [] = []
mergeIntervals (x : xs) = go x xs
  where
    go (a, b) [] = [(a, b)]
    go (a, b) ((c, d) : rest)
      | c <= b + 1 = go (a, max b d) rest
      | otherwise = (a, b) : go (c, d) rest

rowY :: Int
rowY = 2000000

part1 :: String -> Int
part1 s =
  let pairs = map parseLine $ lines s
      intervals =
        mergeIntervals $
          sort
            [ i
              | (sens, _, d) <- pairs,
                Just i <- [intervalRow rowY sens d]
            ]
      covered = sum [b - a + 1 | (a, b) <- intervals]
      beaconsOnRow = length $ nub [bx | (_, (bx, by), _) <- pairs, by == rowY]
   in covered - beaconsOnRow

part2 :: String -> Int
part2 s =
  let pairs = map parseLine $ lines s
      limit = 4000000
      intervalsFor y =
        mergeIntervals $
          sort $
            [ (max 0 a, min limit b)
              | (sens, _, d) <- pairs,
                Just (a, b) <- [intervalRow y sens d],
                b >= 0,
                a <= limit
            ]
      findGap [] = Nothing
      findGap [(a, b)]
        | a > 0 = Just 0
        | b < limit = Just (b + 1)
        | otherwise = Nothing
      findGap ((_a1, b1) : (a2, b2) : rest)
        | b1 + 1 < a2 = Just (b1 + 1)
        | otherwise = findGap ((a2, b2) : rest)
      findY y
        | y > limit = error "Day15: no distress"
        | otherwise =
            case findGap (intervalsFor y) of
              Just x -> x * 4000000 + y
              Nothing -> findY (y + 1)
   in findY 0
