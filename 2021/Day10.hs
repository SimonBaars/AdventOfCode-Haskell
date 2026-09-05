import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (sort)

input :: [String]
input = unsafePerformIO $ readInputLines 2021 10

data ParseResult = Valid | Corrupted Char | Incomplete [Char]

pairs :: [(Char, Char)]
pairs = [('(', ')'), ('[', ']'), ('{', '}'), ('<', '>')]

closing :: Char -> Maybe Char
closing c = lookup c pairs

isOpening :: Char -> Bool
isOpening c = c `elem` map fst pairs

parseLine :: String -> ParseResult
parseLine = go []
  where
    go [] [] = Valid
    go stack [] = Incomplete (reverse stack)
    go stack (c:cs)
        | isOpening c = go (c:stack) cs
        | otherwise = case stack of
            [] -> Corrupted c
            (o:os) -> case closing o of
                Just expected | expected == c -> go os cs
                _ -> Corrupted c

corruptScore :: Char -> Int
corruptScore ')' = 3
corruptScore ']' = 57
corruptScore '}' = 1197
corruptScore '>' = 25137

part1 :: Int
part1 = sum [corruptScore c | Corrupted c <- map parseLine input]

incompleteScore :: [Char] -> Int
incompleteScore = foldl (\acc c -> acc * 5 + charScore c) 0
  where
    charScore c = case closing c of
        Just ')' -> 1
        Just ']' -> 2
        Just '}' -> 3
        Just '>' -> 4

middle :: [a] -> a
middle xs = xs !! (length xs `div` 2)

part2 :: Int
part2 = middle $ sort [incompleteScore cs | Incomplete cs <- map parseLine input]
