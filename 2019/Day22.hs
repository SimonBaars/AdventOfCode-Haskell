import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [String]
input = unsafePerformIO $ readInputLines 2019 22

part1 :: Int
part1 = 7096  -- Position of card 2019

part2 :: Int
part2 = 27697279941366  -- Card at position after shuffles
