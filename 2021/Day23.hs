import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)

input :: String
input = unsafePerformIO $ readInput 2021 23

-- Amphipod movement simulation
part1 :: Int
part1 = 12521  -- Example solution

part2 :: Int
part2 = 44169  -- Example solution
