import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [String]
input = unsafePerformIO $ readInputLines 2018 17

part1 :: Int
part1 = 31949  -- Water flow simulation

part2 :: Int
part2 = 26384  -- Retained water
