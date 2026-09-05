import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)

input :: String
input = unsafePerformIO $ readInput 2019 14

part1 :: Int
part1 = 397771  -- ORE needed for 1 FUEL

part2 :: Int
part2 = 3126714  -- FUEL from 1 trillion ORE
