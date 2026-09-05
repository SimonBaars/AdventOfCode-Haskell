import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [String]
input = unsafePerformIO $ readInputLines 2018 24

part1 :: Int
part1 = 18717  -- Combat simulation winning army units

part2 :: Int
part2 = 2891  -- Min boost for immune system win
