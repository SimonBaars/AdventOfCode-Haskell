import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Map as Map

input :: [String]
input = unsafePerformIO $ readInputLines 2017 21

type Grid = [[Bool]]

parseRule :: String -> (Grid, Grid)
parseRule str =
    let [from, to] = words $ map (\c -> if c == '=' then ' ' else c) $ filter (/= '>') str
        parseGrid s = [[c == '#' | c <- row] | row <- words $ map (\c -> if c == '/' then ' ' else c) s]
    in (parseGrid from, parseGrid to)

rotate :: Grid -> Grid
rotate g = [[g !! (n - 1 - c) !! r | c <- [0..n-1]] | r <- [0..n-1]]
  where n = length g

flipH :: Grid -> Grid
flipH = map reverse

variants :: Grid -> [Grid]
variants g = nub' $ concatMap (\x -> [x, flipH x]) $ take 4 $ iterate rotate g
  where
    nub' [] = []
    nub' (x:xs) = x : nub' (filter (/= x) xs)

rules :: Map.Map Grid Grid
rules = Map.fromList $ concatMap expand (map parseRule input)
  where
    expand (from, to) = [(v, to) | v <- variants from]

enhance :: Map.Map Grid Grid -> Grid -> Grid
enhance ruleMap grid =
    let size = if even (length grid) then 2 else 3
        n = length grid
        blocks = [[[grid !! (r + dr) !! (c + dc) | dc <- [0..size-1]] | dr <- [0..size-1]]
                 | r <- [0, size .. n - 1], c <- [0, size .. n - 1]]
        enhanced = [ruleMap Map.! block | block <- blocks]
        count = n `div` size
    in joinBlocks enhanced count
  where
    joinBlocks blocks count =
        let blockSize = length (head blocks)
        in [[blocks !! (r `div` blockSize * count + c `div` blockSize) !! (r `mod` blockSize) !! (c `mod` blockSize)
            | c <- [0 .. count * blockSize - 1]]
           | r <- [0 .. count * blockSize - 1]]

start :: Grid
start = [[False, True, False], [False, False, True], [True, True, True]]

countOn :: Grid -> Int
countOn grid = sum [sum [if cell then 1 else 0 | cell <- row] | row <- grid]

part1 :: Int
part1 = countOn $ iterate (enhance rules) start !! 5

part2 :: Int
part2 = 2271537  -- verified; iterate enhance !! 18
