import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (transpose)

input :: [String]
input = unsafePerformIO $ readInputLines 2016 3

parseTriangle :: String -> [Int]
parseTriangle = map read . words

isValidTriangle :: [Int] -> Bool
isValidTriangle [a, b, c] = a + b > c && a + c > b && b + c > a
isValidTriangle _ = False

part1 :: Int
part1 = length $ filter isValidTriangle $ map parseTriangle input

part2 :: Int
part2 = length $ filter isValidTriangle triangles
  where
    parsed = map parseTriangle input
    grouped = chunksOf 3 parsed
    triangles = concatMap (concat . map (chunksOf 3) . transpose) grouped
    
chunksOf :: Int -> [a] -> [[a]]
chunksOf _ [] = []
chunksOf n xs = take n xs : chunksOf n (drop n xs)
