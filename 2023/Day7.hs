-- Day 7: Camel Cards
-- Part 1: Rank hands by type and card values
-- Part 2: J becomes joker (weakest card, can be any other)

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (sort, sortBy, group)
import Data.Ord (comparing)

input :: [(String, Int)]
input = unsafePerformIO $ do
    lines <- readInputLines 2023 7
    return [(hand, read bid) | line <- lines, let [hand, bid] = words line]

data HandType = HighCard | OnePair | TwoPair | ThreeKind | FullHouse | FourKind | FiveKind
    deriving (Eq, Ord, Show)

handType :: String -> HandType
handType hand = case sort $ map length $ group $ sort hand of
    [5] -> FiveKind
    [1, 4] -> FourKind
    [2, 3] -> FullHouse
    [1, 1, 3] -> ThreeKind
    [1, 2, 2] -> TwoPair
    [1, 1, 1, 2] -> OnePair
    _ -> HighCard

cardValue :: Char -> Int
cardValue 'A' = 14
cardValue 'K' = 13
cardValue 'Q' = 12
cardValue 'J' = 11
cardValue 'T' = 10
cardValue c = read [c]

cardValue2 :: Char -> Int
cardValue2 'J' = 1
cardValue2 c = cardValue c

bestWithJokers :: String -> HandType
bestWithJokers hand = maximum [handType (replaceJ hand c) | c <- "23456789TQKA"]
  where
    replaceJ h c = map (\x -> if x == 'J' then c else x) h

compareHands :: Bool -> (String, Int) -> (String, Int) -> Ordering
compareHands withJokers (h1, _) (h2, _) = 
    compare (typeVal h1, cardVals h1) (typeVal h2, cardVals h2)
  where
    typeVal = if withJokers then bestWithJokers else handType
    cardVals = map (if withJokers then cardValue2 else cardValue)

calculateWinnings :: Bool -> Int
calculateWinnings withJokers = sum $ zipWith (*) [1..] bids
  where
    sorted = sortBy (compareHands withJokers) input
    bids = map snd sorted

part1 :: Int
part1 = calculateWinnings False

part2 :: Int
part2 = calculateWinnings True
