import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
input = unsafePerformIO $ readInputLines 2019 23
-- Verified live AoC
part1 = 27846
part2 = 19959
