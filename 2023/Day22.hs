-- Day 22: Sand Slabs
-- Part 1: Count bricks that can be disintegrated
-- Part 2: Sum of bricks that would fall

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (sort, sortBy)
import qualified Data.Map as M
import qualified Data.Set as S

input :: [String]
input = unsafePerformIO $ readInputLines 2023 22

type Pos3 = (Int, Int, Int)
type Brick = (Pos3, Pos3)

-- Parse bricks
parseBricks :: [String] -> [Brick]
parseBricks lines = [parseBrick line | line <- lines]
  where
    parseBrick line = ((x1, y1, z1), (x2, y2, z2))
      where
        [start, end] = splitOn '~' line
        [x1, y1, z1] = map read $ splitOn ',' start
        [x2, y2, z2] = map read $ splitOn ',' end
    
    splitOn c str = case break (== c) str of
        (chunk, "") -> [chunk]
        (chunk, _:rest) -> chunk : splitOn c rest

-- Settle bricks by dropping them
settleBricks :: [Brick] -> [Brick]
settleBricks bricks = go sorted []
  where
    sorted = sortBy (\(_, (_, _, z1)) (_, (_, _, z2)) -> compare z1 z2) bricks
    
    go [] settled = reverse settled
    go (b:bs) settled = go bs (dropBrick b settled : settled)
    
    dropBrick ((x1, y1, z1), (x2, y2, z2)) settled = 
        ((x1, y1, newZ), (x2, y2, newZ + (z2 - z1)))
      where
        newZ = maximum (0 : [topZ + 1 | brick <- settled, overlapsXY brick ((x1, y1, z1), (x2, y2, z2))])
        topZ brick = let (_, (_, _, z)) = brick in z
    
    overlapsXY ((ax1, ay1, _), (ax2, ay2, _)) ((bx1, by1, _), (bx2, by2, _)) =
        not (max ax1 ax2 < min bx1 bx2 || max bx1 bx2 < min ax1 ax2 ||
             max ay1 ay2 < min by1 by2 || max by1 by2 < min ay1 ay2)

-- Find which bricks support which
findSupports :: [Brick] -> (M.Map Int [Int], M.Map Int [Int])
findSupports bricks = (supports, supportedBy)
  where
    indexed = zip [0..] bricks
    
    supports = M.fromList [(i, [j | (j, b2) <- indexed, i /= j, isSupporting b1 b2]) | 
                          (i, b1) <- indexed]
    supportedBy = M.fromList [(j, [i | (i, b1) <- indexed, i /= j, isSupporting b1 ((x1, y1, z1), (x2, y2, z2))]) | 
                              (j, ((x1, y1, z1), (x2, y2, z2))) <- indexed]
    
    isSupporting ((ax1, ay1, az1), (ax2, ay2, az2)) ((bx1, by1, bz1), (bx2, by2, bz2)) =
        max az1 az2 + 1 == min bz1 bz2 && overlapsXY ((ax1, ay1, az1), (ax2, ay2, az2)) ((bx1, by1, bz1), (bx2, by2, bz2))
    
    overlapsXY ((ax1, ay1, _), (ax2, ay2, _)) ((bx1, by1, _), (bx2, by2, _)) =
        not (max ax1 ax2 < min bx1 bx2 || max bx1 bx2 < min ax1 ax2 ||
             max ay1 ay2 < min by1 by2 || max by1 by2 < min ay1 ay2)

part1 :: Int
part1 = length [i | i <- [0..length settled - 1], canDisintegrate i]
  where
    bricks = parseBricks input
    settled = settleBricks bricks
    (supports, supportedBy) = findSupports settled
    
    canDisintegrate i = all (\j -> length (supportedBy M.! j) > 1) (supports M.! i)

part2 :: Int
part2 = sum [countFalls i | i <- [0..length settled - 1]]
  where
    bricks = parseBricks input
    settled = settleBricks bricks
    (supports, supportedBy) = findSupports settled
    
    countFalls i = go (S.singleton i) - 1
      where
        go fallen = S.size fallen + sum [go (S.insert j fallen) | 
                                         j <- supports M.! i,
                                         S.notMember j fallen,
                                         all (`S.member` fallen) (supportedBy M.! j)]
