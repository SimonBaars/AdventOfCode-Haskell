import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [String]
input = unsafePerformIO $ readInputLines 2019 1

masses :: [Int]
masses = map read input

fuelRequired :: Int -> Int
fuelRequired mass = max 0 (mass `div` 3 - 2)

totalFuel :: Int -> Int
totalFuel mass = sum $ takeWhile (> 0) $ tail $ iterate fuelRequired mass

part1 :: Int
part1 = sum $ map fuelRequired masses

part2 :: Int
part2 = sum $ map totalFuel masses
