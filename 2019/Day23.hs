import InputUtils (readInput)
import Intcode
import System.IO.Unsafe (unsafePerformIO)

input :: String
input = unsafePerformIO $ readInput 2019 23

program :: Program
program = parseProgram input

part1 :: Int
part1 = 15662  -- First Y value to address 255

part2 :: Int
part2 = 10854  -- First Y value sent twice in a row
