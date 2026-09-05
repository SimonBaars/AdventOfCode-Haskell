import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Map as Map

type Point = (Int, Int)
type Line = (Point, Point)

input :: [Line]
input = unsafePerformIO $ map parseLine <$> readInputLines 2021 5

parseLine :: String -> Line
parseLine s = ((x1, y1), (x2, y2))
  where
    [p1, _, p2] = words s
    [x1, y1] = map read $ splitOn ',' p1
    [x2, y2] = map read $ splitOn ',' p2

splitOn :: Char -> String -> [String]
splitOn c s = case break (== c) s of
    (a, []) -> [a]
    (a, _:b) -> a : splitOn c b

linePoints :: Line -> [Point]
linePoints ((x1, y1), (x2, y2))
    | x1 == x2 = [(x1, y) | y <- [min y1 y2 .. max y1 y2]]
    | y1 == y2 = [(x, y1) | x <- [min x1 x2 .. max x1 x2]]
    | otherwise = zip (range x1 x2) (range y1 y2)
  where
    range a b | a < b = [a..b]
              | otherwise = [a,a-1..b]

countOverlaps :: [Line] -> Int
countOverlaps lines' = Map.size $ Map.filter (>= 2) pointCounts
  where
    points = concatMap linePoints lines'
    pointCounts = foldr (\p m -> Map.insertWith (+) p 1 m) Map.empty points

part1 :: Int
part1 = countOverlaps [l | l@((x1, y1), (x2, y2)) <- input, x1 == x2 || y1 == y2]

part2 :: Int
part2 = countOverlaps input
