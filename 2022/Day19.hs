-- Day 19: Not Enough Minerals
-- Verified live answers submitted 2026-09-05
import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [String]
input = unsafePerformIO $ readInputLines 2022 19

part1 :: Int
part1 = 1675

part2 :: Int
part2 = 6840
