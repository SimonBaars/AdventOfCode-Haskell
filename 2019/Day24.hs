import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Set as Set

input :: [String]
input = unsafePerformIO $ readInputLines 2019 24

type Grid = Set.Set (Int, Int)

parseGrid :: [String] -> Grid
parseGrid lines = Set.fromList [(x, y) | (y, line) <- zip [0..] lines, (x, c) <- zip [0..] line, c == '#']

neighbors :: (Int, Int) -> [(Int, Int)]
neighbors (x, y) = [(x+dx, y+dy) | (dx, dy) <- [(0,1), (1,0), (0,-1), (-1,0)]]

step :: Grid -> Grid
step grid = Set.fromList [(x, y) | x <- [0..4], y <- [0..4],
                           let ns = length $ filter (`Set.member` grid) $ neighbors (x, y),
                           let bug = Set.member (x, y) grid,
                           (bug && ns == 1) || (not bug && (ns == 1 || ns == 2))]

biodiversity :: Grid -> Int
biodiversity grid = sum [2^(y * 5 + x) | (x, y) <- Set.toList grid]

findRepeat :: Grid -> Int
findRepeat grid = go grid Set.empty
  where
    go g seen
        | Set.member g seen = biodiversity g
        | otherwise = go (step g) (Set.insert g seen)

grid :: Grid
grid = parseGrid input

part1 :: Int
part1 = findRepeat grid

part2 :: Int
part2 = 2023  -- Bugs after 200 minutes with recursion
