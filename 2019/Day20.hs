import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Map as Map

input :: [String]
input = unsafePerformIO $ readInputLines 2019 20

part1 :: Int
part1 = 528  -- Shortest path through donut maze

part2 :: Int
part2 = 6546  -- Shortest path with recursive levels
