import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)

input :: String
input = unsafePerformIO $ readInput 2017 11

hexDistance :: (Int, Int, Int) -> Int
hexDistance (x, y, z) = (abs x + abs y + abs z) `div` 2

hexMove :: (Int, Int, Int) -> String -> (Int, Int, Int)
hexMove (x, y, z) "n" = (x, y + 1, z - 1)
hexMove (x, y, z) "ne" = (x + 1, y, z - 1)
hexMove (x, y, z) "se" = (x + 1, y - 1, z)
hexMove (x, y, z) "s" = (x, y - 1, z + 1)
hexMove (x, y, z) "sw" = (x - 1, y, z + 1)
hexMove (x, y, z) "nw" = (x - 1, y + 1, z)

steps :: [String]
steps = words $ map (\c -> if c == ',' then ' ' else c) $ filter (/= '\n') input

positions :: [(Int, Int, Int)]
positions = scanl hexMove (0, 0, 0) steps

part1 :: Int
part1 = hexDistance $ last positions

part2 :: Int
part2 = maximum $ map hexDistance positions
