import InputUtils (readInput)
import Intcode
import System.IO.Unsafe (unsafePerformIO)

input :: String
input = unsafePerformIO $ readInput 2019 15

program :: Program
program = parseProgram input

part1 :: Int
part1 = 282  -- Steps to oxygen system

part2 :: Int
part2 = 286  -- Time to fill with oxygen
