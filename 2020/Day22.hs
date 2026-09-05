import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Set as Set

-- Day 22: Crab Combat
-- Card game simulation with normal and recursive rules

type Deck = [Int]

input :: (Deck, Deck)
input = unsafePerformIO $ parseDecks <$> readInput 2020 22

parseDecks :: String -> (Deck, Deck)
parseDecks s = (deck1, deck2)
  where
    [block1, block2] = splitOn "\n\n" s
    deck1 = map read $ tail $ lines block1
    deck2 = map read $ tail $ lines block2

splitOn :: String -> String -> [String]
splitOn delim str = case breakOn delim str of
    (chunk, "") -> [chunk]
    (chunk, rest) -> chunk : splitOn delim (drop (length delim) rest)

breakOn :: String -> String -> (String, String)
breakOn needle haystack = go [] haystack
  where
    go acc [] = (reverse acc, "")
    go acc s@(c:cs)
        | take (length needle) s == needle = (reverse acc, s)
        | otherwise = go (c:acc) cs

-- Play normal Combat
playCombat :: Deck -> Deck -> Deck
playCombat [] d2 = d2
playCombat d1 [] = d1
playCombat (c1:d1) (c2:d2)
    | c1 > c2 = playCombat (d1 ++ [c1, c2]) d2
    | otherwise = playCombat d1 (d2 ++ [c2, c1])

-- Calculate score
score :: Deck -> Int
score deck = sum $ zipWith (*) (reverse deck) [1..]

part1 :: Int
part1 = score $ uncurry playCombat input

-- Play Recursive Combat
playRecursive :: Deck -> Deck -> (Bool, Deck)
playRecursive d1 d2 = go d1 d2 Set.empty
  where
    go [] d2 _ = (False, d2)
    go d1 [] _ = (True, d1)
    go d1 d2 seen
        | (d1, d2) `Set.member` seen = (True, d1)
        | otherwise = 
            let seen' = Set.insert (d1, d2) seen
                (c1:rest1) = d1
                (c2:rest2) = d2
                p1Wins = if length rest1 >= c1 && length rest2 >= c2
                        then fst $ playRecursive (take c1 rest1) (take c2 rest2)
                        else c1 > c2
            in if p1Wins
               then go (rest1 ++ [c1, c2]) rest2 seen'
               else go rest1 (rest2 ++ [c2, c1]) seen'

part2 :: Int
part2 = score $ snd $ uncurry playRecursive input
