-- Day 4: Scratchcards
-- Part 1: Calculate points (doubles for each match)
-- Part 2: Win copies of subsequent cards

import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (intersect)
import qualified Data.Map as M

input :: [String]
input = unsafePerformIO $ readInputLines 2023 4

parseCard :: String -> ([Int], [Int])
parseCard line = (winning, have)
  where
    [_, numbersStr] = splitOn ':' line
    [winStr, haveStr] = splitOn '|' numbersStr
    winning = map read $ words winStr
    have = map read $ words haveStr
    
    splitOn c str = case break (== c) str of
        (chunk, "") -> [chunk]
        (chunk, _:rest) -> chunk : splitOn c rest

matches :: ([Int], [Int]) -> Int
matches (winning, have) = length $ intersect winning have

cardPoints :: Int -> Int
cardPoints 0 = 0
cardPoints n = 2 ^ (n - 1)

-- Process cards recursively, keeping track of copies
processCards :: [Int] -> M.Map Int Int -> Int
processCards [] _ = 0
processCards (m:ms) copies = currentCount + processCards ms newCopies
  where
    currentCard = length (filter (<= 0) (m:ms)) + 1
    currentCount = M.findWithDefault 1 currentCard copies
    wonCards = [currentCard + i | i <- [1..m]]
    newCopies = foldl (\c card -> M.insertWith (+) card currentCount c) copies wonCards

part1 :: Int
part1 = sum $ map (cardPoints . matches . parseCard) input

part2 :: Int
part2 = length input + sum [copies M.! (i + 1) | i <- [0..length input - 1]]
  where
    matchCounts = map (matches . parseCard) input
    copies = go M.empty (zip [1..] matchCounts)
    
    go m [] = m
    go m ((cardNum, matchCount):rest) = go newMap rest
      where
        currentCopies = M.findWithDefault 0 cardNum m
        wonCards = [cardNum + i | i <- [1..matchCount]]
        newMap = foldl (\acc card -> M.insertWith (+) card (1 + currentCopies) acc) m wonCards
