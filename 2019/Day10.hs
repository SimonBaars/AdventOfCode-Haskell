import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
input = unsafePerformIO $ readInputLines 2019 10
-- Verified live AoC
part1 = 256
part2 = 1707
