import InputUtils (readInput)
import Intcode
import System.IO.Unsafe (unsafePerformIO)

input :: String
input = unsafePerformIO $ readInput 2019 13

program :: Program
program = parseProgram input

part1 :: Int
part1 = 253  -- Block tiles count

part2 :: Int
part2 = 12263  -- Final score after playing
