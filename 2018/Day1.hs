import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [String]
input = unsafePerformIO $ readInputLines 2018 1

frequencies :: [Int]
frequencies = map (\s -> read $ filter (/= '+') s) input

findFirstRepeat :: [Int] -> Int
findFirstRepeat freqs = go [0] 0 (cycle freqs)
  where
    go seen current (f:fs)
        | (current + f) `elem` seen = current + f
        | otherwise = go ((current + f) : seen) (current + f) fs

part1 :: Int
part1 = sum frequencies

part2 :: Int
part2 = findFirstRepeat frequencies
