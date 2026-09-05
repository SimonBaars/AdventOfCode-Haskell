import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Set as Set

-- Day 3: Perfectly Spherical Houses in a Vacuum
-- Track Santa's path on infinite 2D grid

type Position = (Int, Int)

input :: String
input = unsafePerformIO $ readInput 2015 3

-- Move based on direction
move :: Position -> Char -> Position
move (x, y) '^' = (x, y + 1)
move (x, y) 'v' = (x, y - 1)
move (x, y) '>' = (x + 1, y)
move (x, y) '<' = (x - 1, y)
move pos _ = pos

-- Part 1: Santa alone delivers presents
part1 :: Int
part1 = Set.size $ foldl addVisit (Set.singleton (0, 0)) positions
  where
    positions = scanl move (0, 0) input
    addVisit visited pos = Set.insert pos visited

-- Part 2: Santa and Robo-Santa alternate
part2 :: Int
part2 = Set.size $ Set.union santaVisits roboVisits
  where
    santaDirs = [c | (i, c) <- zip [0..] input, even i]
    roboDirs = [c | (i, c) <- zip [0..] input, odd i]
    santaVisits = Set.fromList $ scanl move (0, 0) santaDirs
    roboVisits = Set.fromList $ scanl move (0, 0) roboDirs
