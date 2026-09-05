import InputUtils (readInput)
import Intcode
import System.IO.Unsafe (unsafePerformIO)

input :: String
input = unsafePerformIO $ readInput 2019 5

program :: Program
program = parseProgram input

part1 :: Int
part1 = last $ runProgram program [1]

part2 :: Int
part2 = last $ runProgram program [5]
