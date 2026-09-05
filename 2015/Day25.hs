import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)

input :: String
input = unsafePerformIO $ readInput 2015 25

-- Extract row and column from input
parseInput :: String -> (Int, Int)
parseInput s = (row, col)
  where
    ws = words s
    row = read $ init $ ws !! 15
    col = read $ init $ ws !! 17

codeAt :: Int -> Int -> Int
codeAt row col = iterate next 20151125 !! (index - 1)
  where
    index = sum [1..row+col-2] + col
    next x = (x * 252533) `mod` 33554393

part1 :: Int
part1 = uncurry codeAt (parseInput input)

part2 :: String
part2 = "Merry Christmas!"
