import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)

input :: Int
input = unsafePerformIO $ read <$> readInput 2015 20

divisors :: Int -> [Int]
divisors n = [i | i <- [1..n], n `mod` i == 0]

presents1 :: Int -> Int
presents1 house = 10 * sum (divisors house)

presents2 :: Int -> Int
presents2 house = 11 * sum (filter (\d -> house `div` d <= 50) $ divisors house)

part1 :: Int
part1 = head [h | h <- [1..], presents1 h >= input]

part2 :: Int
part2 = head [h | h <- [1..], presents2 h >= input]
