import Data.List (isInfixOf, tails)
import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [String]
input = unsafePerformIO $ readInputLines 2015 5

vowels :: String -> Int
vowels = length . filter (`elem` "aeiou")

hasDouble :: String -> Bool
hasDouble s = any (uncurry (==)) $ zip s (tail s)

nice1 :: String -> Bool
nice1 s = vowels s >= 3 && hasDouble s && not (any (`isInfixOf` s) ["ab","cd","pq","xy"])

hasPairTwice :: String -> Bool
hasPairTwice s = or
  [ take 2 (drop i s) == take 2 (drop j s)
  | i <- [0 .. length s - 2]
  , j <- [i+2 .. length s - 2]
  ]

hasRepeatGap :: String -> Bool
hasRepeatGap s = or [ a == c | (a:_:c:_) <- tails s ]

nice2 :: String -> Bool
nice2 s = hasPairTwice s && hasRepeatGap s

part1 :: Int
part1 = length $ filter nice1 input

part2 :: Int
part2 = length $ filter nice2 input
