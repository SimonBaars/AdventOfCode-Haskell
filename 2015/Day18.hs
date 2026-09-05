import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Set as Set

input :: [[Char]]
input = unsafePerformIO $ readInputLines 2015 18

type Grid = Set.Set (Int, Int)

parseGrid :: [[Char]] -> Grid
parseGrid lines' = Set.fromList [(x, y) | (y, row) <- zip [0..] lines', (x, c) <- zip [0..] row, c == '#']

neighbors :: (Int, Int) -> [(Int, Int)]
neighbors (x, y) = [(x+dx, y+dy) | dx <- [-1..1], dy <- [-1..1], (dx, dy) /= (0, 0)]

step :: Grid -> Grid
step grid = Set.fromList [pos | pos <- candidates, shouldBeOn pos]
  where
    candidates = Set.toList grid ++ concatMap neighbors (Set.toList grid)
    shouldBeOn pos = let n = length $ filter (`Set.member` grid) (neighbors pos)
                     in n == 3 || (n == 2 && pos `Set.member` grid)

part1 :: Int
part1 = Set.size $ iterate step (parseGrid input) !! 100

part2 :: Int
part2 = Set.size $ iterate step' (parseGrid input) !! 100
  where
    corners = Set.fromList [(0,0), (0,99), (99,0), (99,99)]
    step' g = Set.union corners $ step g
