import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Set as Set

input :: [String]
input = unsafePerformIO $ readInputLines 2018 12

type State = (Set.Set Int, Int)

parseInitial :: String -> Set.Set Int
parseInitial str = Set.fromList [i | (i, c) <- zip [0..] (drop 15 str), c == '#']

parseRule :: String -> (String, Char)
parseRule str = (take 5 str, last str)

step :: [(String, Char)] -> State -> State
step rules (pots, offset) =
    let minPot = Set.findMin pots - 5
        maxPot = Set.findMax pots + 5
        pattern i = [if Set.member (i + j - 2) pots then '#' else '.' | j <- [0..4]]
        newPots = Set.fromList [i | i <- [minPot..maxPot], lookup (pattern i) rules == Just '#']
    in (newPots, offset)

sumPots :: State -> Int
sumPots (pots, offset) = sum $ Set.toList pots

initial :: Set.Set Int
initial = parseInitial $ head input

rules :: [(String, Char)]
rules = map parseRule $ drop 2 input

part1 :: Int
part1 = sumPots $ iterate (step rules) (initial, 0) !! 20

part2 :: Int
part2 = let states = take 200 $ iterate (step rules) (initial, 0)
            sums = map sumPots states
            diffs = zipWith (-) (tail sums) sums
            stable = head [d | (d1:d2:d3:_) <- take 150 $ iterate tail diffs, d1 == d2 && d2 == d3]
            base = sums !! 150
        in base + stable * (50000000000 - 150)
