import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Map as Map
import Data.List (intercalate)

input :: [String]
input = unsafePerformIO $ readInputLines 2017 21

type Grid = [[Bool]]

parseRule :: String -> (Grid, Grid)
parseRule str =
    let [from, to] = words $ map (\c -> if c == '=' then ' ' else c) $ filter (/= '>') str
        parseGrid s = [[c == '#' | c <- row] | row <- words $ map (\c -> if c == '/' then ' ' else c) s]
    in (parseGrid from, parseGrid to)

rules :: Map.Map Grid Grid
rules = Map.fromList $ map parseRule input

enhance :: Map.Map Grid Grid -> Grid -> Grid
enhance ruleMap grid =
    let size = if length grid `mod` 2 == 0 then 2 else 3
        blocks = [[[grid !! (r + dr) !! (c + dc) | dc <- [0..size-1]] | dr <- [0..size-1]] | r <- [0, size..length grid - 1], c <- [0, size..length (head grid) - 1]]
        enhanced = [Map.findWithDefault block block ruleMap | block <- blocks]
    in joinBlocks enhanced (length grid `div` size)
  where
    joinBlocks blocks count =
        let blockSize = length (head blocks)
        in [[blocks !! (r `div` blockSize * count + c `div` blockSize) !! (r `mod` blockSize) !! (c `mod` blockSize) | c <- [0..count * blockSize - 1]] | r <- [0..count * blockSize - 1]]

start :: Grid
start = [[False, True, False], [False, False, True], [True, True, True]]

countOn :: Grid -> Int
countOn grid = sum [sum [if cell then 1 else 0 | cell <- row] | row <- grid]

part1 :: Int
part1 = countOn $ iterate (enhance rules) start !! 5

part2 :: Int
part2 = countOn $ iterate (enhance rules) start !! 18
