import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Map as Map

input :: [String]
input = unsafePerformIO $ readInputLines 2018 6

type Point = (Int, Int)

parsePoint :: String -> Point
parsePoint str = case words $ map (\c -> if c == ',' then ' ' else c) str of
    [x, y] -> (read x, read y)
    _ -> error "Invalid"

manhattan :: Point -> Point -> Int
manhattan (x1, y1) (x2, y2) = abs (x1 - x2) + abs (y1 - y2)

findClosest :: [Point] -> Point -> Maybe Int
findClosest points p =
    let distances = [(i, manhattan p pt) | (i, pt) <- zip [0..] points]
        minDist = minimum $ map snd distances
        closest = [i | (i, d) <- distances, d == minDist]
    in if length closest == 1 then Just (head closest) else Nothing

points :: [Point]
points = map parsePoint input

bounds :: (Int, Int, Int, Int)
bounds = (minimum xs, maximum xs, minimum ys, maximum ys)
  where (xs, ys) = unzip points

part1 :: Int
part1 = maximum [length [p | p <- allPoints, findClosest points p == Just i] | i <- [0..length points - 1], isInner i]
  where
    (minX, maxX, minY, maxY) = bounds
    allPoints = [(x, y) | x <- [minX..maxX], y <- [minY..maxY]]
    isInner i = not $ any (\(x, y) -> (x == minX || x == maxX || y == minY || y == maxY) && findClosest points (x, y) == Just i) allPoints

part2 :: Int
part2 = length [p | p <- allPoints, sum [manhattan p pt | pt <- points] < 10000]
  where
    (minX, maxX, minY, maxY) = bounds
    allPoints = [(x, y) | x <- [minX..maxX], y <- [minY..maxY]]
