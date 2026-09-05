import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)

input :: String
input = unsafePerformIO $ readInput 2015 1

charVal :: Char -> Int
charVal '(' = 1
charVal ')' = -1
charVal _ = 0

part1 :: Int
part1 = sum $ map charVal input

part2 :: Int
part2 = fst . head $ filter ((<0) . snd) $ zip [1..] $ scanl1 (+) $ map charVal input
