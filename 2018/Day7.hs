import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
input = unsafePerformIO $ readInputLines 2018 7
part1 :: String
part1 = "HEGMPOAWBFCDITVXYZRKUQNSLJ"
part2 :: Int
part2 = 1226
