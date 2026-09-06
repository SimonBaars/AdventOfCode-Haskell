import InputUtils (readInput)
import Intcode
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Set as Set

input :: String
input = unsafePerformIO $ readInput 2019 3

type Point = (Int, Int)

parsePath :: String -> [(Char, Int)]
parsePath path = map parseMove $ words $ map (\c -> if c == ',' then ' ' else c) path
  where parseMove (d:num) = (d, read num)

pathPoints :: [(Char, Int)] -> [Point]
pathPoints moves = scanl move (0, 0) (concatMap expandMove moves)
  where
    expandMove (d, n) = replicate n d
    move (x, y) 'U' = (x, y + 1)
    move (x, y) 'D' = (x, y - 1)
    move (x, y) 'L' = (x - 1, y)
    move (x, y) 'R' = (x + 1, y)

manhattan :: Point -> Int
manhattan (x, y) = abs x + abs y

[wire1, wire2] = lines input
points1 = tail $ pathPoints $ parsePath wire1
points2 = tail $ pathPoints $ parsePath wire2

intersections :: [Point]
intersections = Set.toList $ Set.intersection (Set.fromList points1) (Set.fromList points2)

part1 :: Int
part1 = minimum $ map manhattan intersections

part2 :: Int
part2 = minimum [steps1 + steps2 | p <- intersections,
                 let steps1 = length (takeWhile (/= p) points1) + 1,
                 let steps2 = length (takeWhile (/= p) points2) + 1]
