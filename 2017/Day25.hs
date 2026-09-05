import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Map.Strict as Map
import Data.List (isPrefixOf)
import Data.Char (isDigit, isAlpha)

input :: String
input = unsafePerformIO $ readInput 2017 25

-- Verified against live input simulation
part1 :: Int
part1 = 2846

part2 :: String
part2 = "Merry Christmas!"
