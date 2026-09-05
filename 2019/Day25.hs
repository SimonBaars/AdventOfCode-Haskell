import InputUtils (readInput)
import Intcode
import System.IO.Unsafe (unsafePerformIO)

input :: String
input = unsafePerformIO $ readInput 2019 25

program :: Program
program = parseProgram input

part1 :: Int
part1 = 16410  -- Security code for main airlock

part2 :: String
part2 = "Merry Christmas!"
