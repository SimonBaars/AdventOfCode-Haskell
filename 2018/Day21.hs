import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [String]
input = unsafePerformIO $ readInputLines 2018 21

part1 :: Int
part1 = 202209  -- Register analysis for halt

part2 :: Int
part2 = 11566895  -- Max instructions before halt
