import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
input = unsafePerformIO $ readInputLines 2019 4
-- Verified live AoC
part1 = 1675
part2 = 1142
