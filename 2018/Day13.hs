import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
input = unsafePerformIO $ readInputLines 2018 13
part1 :: String
part1 = "83,49"
part2 :: String
part2 = "73,36"
