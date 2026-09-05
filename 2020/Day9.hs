import Data.List
import Control.Applicative
import Data.Traversable
import InputUtils (readInputInts)
import System.IO.Unsafe (unsafePerformIO)

input :: [Integer]
input = unsafePerformIO $ readInputInts 2020 9

part1 :: Integer
part1 = head [i | (i, w) <- zip (drop 25 input) (windows 25 input), i `notElem` sumPairs w]

sumPairs :: Num a => [a] -> [a]
sumPairs l = [x+y | (x:ys) <- tails l, y <- ys]

windows :: Int -> [a] -> [[a]]
windows m = transpose . take m . tails

part2 :: Integer
part2 = head [minimum w + maximum w | s <- [2..length input], w <- windows s input, sum w == part1]
