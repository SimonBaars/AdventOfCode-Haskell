import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (transpose, group, sort, sortBy)
import Data.Ord (comparing, Down(..))

input :: [String]
input = unsafePerformIO $ readInputLines 2016 6

mostCommon :: String -> Char
mostCommon = head . head . sortBy (comparing (Down . length)) . group . sort

leastCommon :: String -> Char
leastCommon = head . head . sortBy (comparing length) . group . sort

part1 :: String
part1 = map mostCommon $ transpose input

part2 :: String
part2 = map leastCommon $ transpose input
