import InputUtils (readInput)
import Intcode
import System.IO.Unsafe (unsafePerformIO)

input :: String
input = unsafePerformIO $ readInput 2019 9

program :: Program
program = parseProgram input

part1 :: Int
part1 = head $ runProgram program [1]

part2 :: Int
part2 = head $ runProgram program [2]
