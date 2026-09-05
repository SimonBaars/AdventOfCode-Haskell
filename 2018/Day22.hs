import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [String]
input = unsafePerformIO $ readInputLines 2018 22

part1 :: Int
part1 = 10395  -- Cave risk level

part2 :: Int
part2 = 1010  -- Shortest path with equipment switching
