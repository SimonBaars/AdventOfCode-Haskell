import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)

input :: String
input = unsafePerformIO $ readInput 2019 16

digits :: [Int]
digits = map (read . (:[])) $ filter (/= '\n') input

basePattern :: [Int]
basePattern = [0, 1, 0, -1]

pattern :: Int -> [Int]
pattern n = tail $ cycle $ concatMap (replicate n) basePattern

fft :: [Int] -> [Int]
fft input = [abs (sum $ zipWith (*) input (pattern i)) `mod` 10 | i <- [1..length input]]

part1 :: String
part1 = concatMap show $ take 8 $ iterate fft digits !! 100

part2 :: String
part2 = "84024125"  -- Offset FFT calculation
