import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [String]
input = unsafePerformIO $ readInputLines 2017 2

parseRow :: String -> [Int]
parseRow = map read . words

checksum1 :: [[Int]] -> Int
checksum1 rows = sum [maximum row - minimum row | row <- rows]

checksum2 :: [[Int]] -> Int
checksum2 rows = sum [x `div` y | row <- rows, x <- row, y <- row, x > y, x `mod` y == 0]

rows :: [[Int]]
rows = map parseRow input

part1 :: Int
part1 = checksum1 rows

part2 :: Int
part2 = checksum2 rows
