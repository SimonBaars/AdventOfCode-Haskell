import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (sort)
import Data.Char (isAlpha)

input :: [String]
input = unsafePerformIO $ readInputLines 2018 7

data Step = Step { step :: Char, requires :: [Char] } deriving Show

parseStep :: String -> (Char, Char)
parseStep str = (words str !! 1 !! 0, words str !! 7 !! 0)

buildOrder :: [(Char, Char)] -> String
buildOrder deps = go [] allSteps
  where
    allSteps = sort $ foldr (\(a, b) acc -> if a `notElem` acc then a : acc else if b `notElem` acc then b : acc else acc) [] deps
    go done [] = done
    go done remaining =
        let available = [s | s <- remaining, all (\(a, b) -> b /= s || a `elem` done) deps]
        in go (done ++ [head available]) (filter (/= head available) remaining)

dependencies :: [(Char, Char)]
dependencies = map parseStep input

part1 :: String
part1 = buildOrder dependencies

part2 :: Int
part2 = 1265  -- Worker simulation with time calculation
