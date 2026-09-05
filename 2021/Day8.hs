import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (find, sort, (\\))
import qualified Data.Set as Set

type Pattern = Set.Set Char

input :: [([Pattern], [Pattern])]
input = unsafePerformIO $ map parseLine <$> readInputLines 2021 8

parseLine :: String -> ([Pattern], [Pattern])
parseLine s = (map Set.fromList signals, map Set.fromList outputs)
  where
    [signalPart, outputPart] = words' s '|'
    signals = words signalPart
    outputs = words outputPart

words' :: String -> Char -> [String]
words' s c = case break (== c) s of
    (a, []) -> [a]
    (a, _:b) -> a : words' b c

part1 :: Int
part1 = length [p | (_, outputs) <- input, p <- outputs, Set.size p `elem` [2, 3, 4, 7]]

decodeDisplay :: ([Pattern], [Pattern]) -> Int
decodeDisplay (signals, outputs) = foldl (\acc d -> acc * 10 + d) 0 $ map decode outputs
  where
    one = head [p | p <- signals, Set.size p == 2]
    four = head [p | p <- signals, Set.size p == 4]
    seven = head [p | p <- signals, Set.size p == 3]
    eight = head [p | p <- signals, Set.size p == 7]
    
    three = head [p | p <- signals, Set.size p == 5, one `Set.isSubsetOf` p]
    nine = head [p | p <- signals, Set.size p == 6, four `Set.isSubsetOf` p]
    zero = head [p | p <- signals, Set.size p == 6, p /= nine, one `Set.isSubsetOf` p]
    six = head [p | p <- signals, Set.size p == 6, p /= nine, p /= zero]
    five = head [p | p <- signals, Set.size p == 5, p /= three, p `Set.isSubsetOf` nine]
    two = head [p | p <- signals, Set.size p == 5, p /= three, p /= five]
    
    decode p | p == zero = 0
             | p == one = 1
             | p == two = 2
             | p == three = 3
             | p == four = 4
             | p == five = 5
             | p == six = 6
             | p == seven = 7
             | p == eight = 8
             | p == nine = 9

part2 :: Int
part2 = sum $ map decodeDisplay input
