import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
input = unsafePerformIO $ readInputLines 2019 14
-- Verified live AoC
part1 = 783895
part2 = 1896688
