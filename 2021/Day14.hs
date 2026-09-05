import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Map as Map

type Rules = Map.Map (Char, Char) Char
type PairCounts = Map.Map (Char, Char) Integer

input :: (String, Rules)
input = unsafePerformIO $ parseInput <$> readInput 2021 14

parseInput :: String -> (String, Rules)
parseInput s = (template, rules)
  where
    [template, rulesStr] = splitOn "\n\n" s
    rules = Map.fromList [(parsePair l) | l <- lines rulesStr]
    parsePair l = let [pair, [result]] = splitOn " -> " l
                  in ((head pair, pair !! 1), result)

splitOn :: String -> String -> [String]
splitOn sep s = case breakStr sep s of
    (a, []) -> [a]
    (a, rest) -> a : splitOn sep (drop (length sep) rest)

breakStr :: String -> String -> (String, String)
breakStr sep s = go [] s
  where
    go acc [] = (reverse acc, [])
    go acc str | take (length sep) str == sep = (reverse acc, str)
               | otherwise = go (head str : acc) (tail str)

toPairCounts :: String -> PairCounts
toPairCounts s = Map.fromListWith (+) [((a, b), 1) | (a, b) <- zip s (tail s)]

stepPairs :: Rules -> PairCounts -> PairCounts
stepPairs rules pairs = Map.fromListWith (+) newPairs
  where
    newPairs = [(p, c) | ((a, b), count) <- Map.toList pairs
                       , let mid = Map.findWithDefault ' ' (a, b) rules
                       , p <- if mid == ' ' then [(a, b)] else [(a, mid), (mid, b)]
                       , c <- [count]]

solve :: Int -> Int
solve steps = maximum counts - minimum counts
  where
    (template, rules) = input
    pairs = iterate (stepPairs rules) (toPairCounts template) !! steps
    charCounts = Map.fromListWith (+) $ 
        (head template, 1) : (last template, 1) : [(c, count) | ((a, b), count) <- Map.toList pairs, c <- [a, b]]
    counts = [c `div` 2 | c <- Map.elems charCounts]

part1 :: Int
part1 = solve 10

part2 :: Int
part2 = solve 40
