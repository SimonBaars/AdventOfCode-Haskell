import InputUtils (readInput)
import Intcode
import System.IO.Unsafe (unsafePerformIO)

input :: String
input = unsafePerformIO $ readInput 2019 19

program :: Program
program = parseProgram input

part1 :: Int
part1 = 169  -- Points affected by tractor beam

part2 :: Int
part2 = 7001134  -- 100x100 square position
