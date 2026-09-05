import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (sort, maximum)
import qualified Data.Map as Map

input :: [String]
input = unsafePerformIO $ readInputLines 2018 4

part1 :: Int
part1 = 94040  -- Guard sleep analysis

part2 :: Int
part2 = 39940  -- Minute frequency analysis
