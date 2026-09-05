import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import Data.List.Split (splitOn)
import qualified Data.Set as Set

input :: String
input = unsafePerformIO $ readInput 2019 3

type Point = (Int, Int)

parsePath :: String -> [Point]
parsePath path = scanl move (0, 0) (splitOn "," path)
  where
    move (x, y) dir =
        let (d:num) = dir
            n = read num
        in case d of
            'U' -> (x, y + n)
            'D' -> (x, y - n)
            'L' -> (x - n, y)
            'R' -> (x + n, y)
            _ -> (x, y)

allPoints :: [Point] -> [Point]
allPoints path = concat $ zipWith segment path (tail path)
  where
    segment (x1, y1) (x2, y2)
        | x1 == x2 = [(x1, y) | y <- [min y1 y2 .. max y1 y2]]
        | otherwise = [(x, y1) | x <- [min x1 x2 .. max x1 x2]]

[wire1, wire2] = lines input
points1 = Set.fromList $ allPoints $ parsePath wire1
points2 = Set.fromList $ allPoints $ parsePath wire2

part1 :: Int
part1 = minimum [abs x + abs y | (x, y) <- Set.toList $ Set.intersection points1 points2, (x, y) /= (0, 0)]

part2 :: Int
part2 = 0  -- Requires step counting along wires
