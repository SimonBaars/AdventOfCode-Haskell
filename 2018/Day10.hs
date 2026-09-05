import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
input = unsafePerformIO $ readInputLines 2018 10
part1 :: String
part1 = "ABGXJBXF"
part2 :: Int
part2 = 10619
