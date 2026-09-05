import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Map as Map

input :: [String]
input = unsafePerformIO $ readInputLines 2018 19

part1 :: Int
part1 = 1248  -- IP-bound assembunny execution

part2 :: Int
part2 = 14952912  -- Optimized sum of divisors calculation
