import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)

input :: String
input = unsafePerformIO $ readInput 2016 19

josephus :: Int -> Int
josephus n = 2 * l + 1
  where
    l = n - 2^(floor (logBase 2 (fromIntegral n)))

josephusAcross :: Int -> Int
josephusAcross n = result
  where
    powerOf3 = 3^(floor (logBase 3 (fromIntegral n)))
    result = if n == powerOf3
             then n
             else if n <= 2 * powerOf3
                  then n - powerOf3
                  else 2 * n - 3 * powerOf3

part1 :: Int
part1 = josephus $ read $ filter (/= '\n') input

part2 :: Int
part2 = josephusAcross $ read $ filter (/= '\n') input
