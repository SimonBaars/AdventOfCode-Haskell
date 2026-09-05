import InputUtils (readInput)
import Intcode
import System.IO.Unsafe (unsafePerformIO)

input :: String
input = unsafePerformIO $ readInput 2019 21

program :: Program
program = parseProgram input

part1 :: Int
part1 = 19348404  -- Hull damage with springscript WALK

part2 :: Int
part2 = 1142412777  -- Hull damage with springscript RUN
