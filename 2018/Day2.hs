import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (group, sort)

input :: [String]
input = unsafePerformIO $ readInputLines 2018 2

countLetters :: String -> (Bool, Bool)
countLetters str = (any (== 2) counts, any (== 3) counts)
  where counts = map length $ group $ sort str

differByOne :: String -> String -> Bool
differByOne a b = length [() | (x, y) <- zip a b, x /= y] == 1

commonLetters :: String -> String -> String
commonLetters a b = [x | (x, y) <- zip a b, x == y]

part1 :: Int
part1 = twos * threes
  where
    counts = map countLetters input
    twos = length $ filter fst counts
    threes = length $ filter snd counts

part2 :: String
part2 = head [commonLetters a b | a <- input, b <- input, differByOne a b]
