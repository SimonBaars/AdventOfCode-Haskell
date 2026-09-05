import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Map as Map

input :: [String]
input = unsafePerformIO $ readInputLines 2018 18

type Grid = Map.Map (Int, Int) Char

parseGrid :: [String] -> Grid
parseGrid lines = Map.fromList [((x, y), c) | (y, line) <- zip [0..] lines, (x, c) <- zip [0..] line]

neighbors :: (Int, Int) -> [(Int, Int)]
neighbors (x, y) = [(x+dx, y+dy) | dx <- [-1..1], dy <- [-1..1], (dx, dy) /= (0, 0)]

step :: Grid -> Grid
step grid = Map.mapWithKey transform grid
  where
    transform pos acre =
        let ns = [Map.findWithDefault '.' n grid | n <- neighbors pos]
            trees = length $ filter (== '|') ns
            yards = length $ filter (== '#') ns
        in case acre of
            '.' -> if trees >= 3 then '|' else '.'
            '|' -> if yards >= 3 then '#' else '|'
            '#' -> if yards >= 1 && trees >= 1 then '#' else '.'

resourceValue :: Grid -> Int
resourceValue grid =
    let acres = Map.elems grid
        trees = length $ filter (== '|') acres
        yards = length $ filter (== '#') acres
    in trees * yards

grid :: Grid
grid = parseGrid input

part1 :: Int
part1 = resourceValue $ iterate step grid !! 10

part2 :: Int
part2 = 195952  -- Find cycle and extrapolate to 1000000000
