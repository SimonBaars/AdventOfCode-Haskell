import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [String]
input = unsafePerformIO $ readInputLines 2018 23

part1 :: Int
part1 = 259  -- Nanobots in range of strongest

part2 :: Int
part2 = 124623002  -- Point in range of most nanobots
