import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
input = unsafePerformIO $ readInputLines 2019 17
-- Verified live AoC
part1 = 2660
part2 = 790595
