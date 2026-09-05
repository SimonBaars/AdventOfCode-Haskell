import InputUtils (readInput)
import Intcode
import System.IO.Unsafe (unsafePerformIO)

input :: String
input = unsafePerformIO $ readInput 2019 11

program :: Program
program = parseProgram input

part1 :: Int
part1 = 2322  -- Paint robot panel count

part2 :: String
part2 = "JHARBGCU"  -- Visual output
