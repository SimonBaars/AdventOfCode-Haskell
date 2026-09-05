import Data.List
import InputUtils (readInputInts)
import System.IO.Unsafe (unsafePerformIO)

input :: [Integer]
input = unsafePerformIO $ readInputInts 2020 10

part1 :: Integer
part1 = (calcAnswer . diff) getInput

calcAnswer :: [Integer] -> Integer
calcAnswer xs = genericLength (filter (==3) xs) * genericLength (filter (==1) xs)

getInput :: [Integer]
getInput = sort $ maximum input + 3 : 0 : input

diff [] = []
diff ls = zipWith (-) (tail ls) ls

part2 :: Integer
part2 = head $ foldr (\i acc -> sum [acc !! (j-i-1) | j <- [i+1..i+3], j < length n, (n !! j) - (n !! i) <= 3] : acc) [1] [0..length n-2]
  where n = getInput
