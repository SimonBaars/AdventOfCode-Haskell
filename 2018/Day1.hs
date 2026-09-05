import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Set as Set

input :: [String]
input = unsafePerformIO $ readInputLines 2018 1

frequencies :: [Int]
frequencies = map (\s -> read $ filter (/= '+') s) input

findFirstRepeat :: [Int] -> Int
findFirstRepeat freqs = go (Set.singleton 0) 0 (cycle freqs)
  where
    go seen current (f:fs)
        | Set.member (current + f) seen = current + f
        | otherwise = go (Set.insert (current + f) seen) (current + f) fs

part1 :: Int
part1 = sum frequencies

part2 :: Int
part2 = findFirstRepeat frequencies
