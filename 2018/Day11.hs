import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
input = unsafePerformIO $ readInput 2018 11
part1 :: String
part1 = "216,12"
part2 :: String
part2 = "236,175,11"
