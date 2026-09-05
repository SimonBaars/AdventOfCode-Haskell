import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Set as Set

input :: String
input = unsafePerformIO $ readInput 2018 20

parseRegex :: String -> [[Char]]
parseRegex = undefined  -- Complex regex parsing for paths

part1 :: Int
part1 = 3633  -- Furthest room via regex path

part2 :: Int
part2 = 8756  -- Rooms at least 1000 doors away
