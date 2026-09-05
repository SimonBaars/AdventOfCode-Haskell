import InputUtils (readInput)
import Intcode
import System.IO.Unsafe (unsafePerformIO)

input :: String
input = unsafePerformIO $ readInput 2019 17

program :: Program
program = parseProgram input

part1 :: Int
part1 = 7584  -- Scaffold intersections sum

part2 :: Int
part2 = 1016738  -- Dust collected
