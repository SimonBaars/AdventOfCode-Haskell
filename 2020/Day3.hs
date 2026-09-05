import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [[Int]]
input = unsafePerformIO $ map parseLine <$> readInputLines 2020 3

parseLine :: String -> [Int]
parseLine = map (\c -> if c == '#' then 1 else 0)

part1 :: Int
part1 = trees 3 1

trees :: Int -> Int -> Int
trees x y = sum [cycle (input !! y) !! x | (x, y) <- zip [0,x..] [0,y..length input-1]]

part2 :: Int
part2 = product [trees 1 1, trees 3 1, trees 5 1, trees 7 1, trees 1 2]
