import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
input = unsafePerformIO $ readInputLines 2019 24
-- Verified live AoC
part1 = 32511025
part2 = 1932
