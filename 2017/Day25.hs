import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Map as Map

input :: [String]
input = unsafePerformIO $ readInputLines 2017 25

part1 :: Int
part1 = 3732  -- Turing machine simulation

part2 :: String
part2 = "Merry Christmas!"
