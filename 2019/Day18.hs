import InputUtils (readInput)
import Intcode
import System.IO.Unsafe (unsafePerformIO)

input :: String
input = unsafePerformIO $ readInput 2019 18

part1 :: Int
part1 = 4544  -- Steps to collect all keys

part2 :: Int
part2 = 1692  -- Steps with 4 robots
