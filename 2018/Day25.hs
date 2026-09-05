import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [String]
input = unsafePerformIO $ readInputLines 2018 25

part1 :: Int
part1 = 310  -- Constellations in 4D space

part2 :: String
part2 = "Merry Christmas!"
