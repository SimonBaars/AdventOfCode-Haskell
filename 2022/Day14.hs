-- Day 14: Regolith Reservoir
-- Part 1: Count sand units before flowing into abyss
-- Part 2: Count sand units with floor until source blocked

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Set as S

type Pos = (Int, Int)

input :: [String]
input = unsafePerformIO $ readInputLines 2022 14

-- Parse rock paths
parseRocks :: [String] -> S.Set Pos
parseRocks lines = S.unions [parseLine line | line <- lines]
  where
    parseLine line = S.fromList $ concatMap lineSegment $ zip points (tail points)
      where
        points = map parsePoint $ splitOn " -> " line
        parsePoint s = let [x, y] = map read $ splitOn "," s in (x, y)
    
    lineSegment ((x1, y1), (x2, y2))
        | x1 == x2 = [(x1, y) | y <- [min y1 y2..max y1 y2]]
        | otherwise = [(x, y1) | x <- [min x1 x2..max x1 x2]]
    
    splitOn :: String -> String -> [String]
    splitOn delim str = case breakOn delim str of
        (chunk, "") -> [chunk]
        (chunk, rest) -> chunk : splitOn delim (drop (length delim) rest)
    
    breakOn :: String -> String -> (String, String)
    breakOn delim str = go [] str
      where
        go acc s
            | take (length delim) s == delim = (reverse acc, s)
            | null s = (reverse acc, "")
            | otherwise = go (head s : acc) (tail s)

-- Simulate falling sand
simulate :: S.Set Pos -> Bool -> Int
simulate rocks hasFloor = go rocks 0
  where
    maxY = maximum [y | (_, y) <- S.toList rocks]
    floorY = maxY + 2
    
    go occupied count
        | not hasFloor && sandY > maxY = count
        | hasFloor && S.member (500, 0) occupied = count
        | otherwise = go (S.insert sandPos occupied) (count + 1)
      where
        (sandX, sandY) = dropSand (500, 0) occupied
        sandPos = (sandX, sandY)
    
    dropSand (x, y) occupied
        | hasFloor && y + 1 == floorY = (x, y)
        | not hasFloor && y > maxY = (x, y + 1)
        | not (S.member (x, y + 1) occupied) = dropSand (x, y + 1) occupied
        | not (S.member (x - 1, y + 1) occupied) = dropSand (x - 1, y + 1) occupied
        | not (S.member (x + 1, y + 1) occupied) = dropSand (x + 1, y + 1) occupied
        | otherwise = (x, y)

part1 :: Int
part1 = simulate (parseRocks input) False

part2 :: Int
part2 = simulate (parseRocks input) True
