import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (subsequences)

input :: [Int]
input = unsafePerformIO $ map read <$> readInputLines 2015 17

part1 :: Int
part1 = length $ filter ((== 150) . sum) $ subsequences input

part2 :: Int
part2 = length $ filter (\s -> length s == minLen && sum s == 150) $ subsequences input
  where
    valid = filter ((== 150) . sum) $ subsequences input
    minLen = minimum $ map length valid
