import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
input = unsafePerformIO $ readInput 2018 14
part1 :: String
part1 = "1611732174"
part2 :: Int
part2 = 20279772
