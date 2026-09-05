import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (subsequences, sort)

input :: [Int]
input = unsafePerformIO $ map read <$> readInputLines 2015 24

quantumEntanglement :: [Int] -> Int
quantumEntanglement = product

validGroups :: Int -> [Int] -> [[Int]]
validGroups n packages = [g | g <- subsequences packages, sum g == target]
  where
    target = sum packages `div` n

part1 :: Int
part1 = minimum $ map quantumEntanglement $ head $ filter (not . null) 
        [filter ((== len) . length) groups | len <- [1..]]
  where
    groups = validGroups 3 input

part2 :: Int
part2 = minimum $ map quantumEntanglement $ head $ filter (not . null)
        [filter ((== len) . length) groups | len <- [1..]]
  where
    groups = validGroups 4 input
