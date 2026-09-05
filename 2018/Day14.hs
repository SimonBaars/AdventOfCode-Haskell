import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (tails)

input :: String
input = unsafePerformIO $ readInput 2018 14

recipes :: [Int]
recipes = map (read . (:[])) $ filter (/= '\n') input

recipeSequence :: [Int]
recipeSequence = 3 : 7 : go [3, 7] 0 1
  where
    go state elf1 elf2 =
        let score1 = state !! elf1
            score2 = state !! elf2
            newScore = score1 + score2
            newRecipes = if newScore >= 10 then [1, newScore `mod` 10] else [newScore]
            newState = state ++ newRecipes
            newElf1 = (elf1 + score1 + 1) `mod` length newState
            newElf2 = (elf2 + score2 + 1) `mod` length newState
        in newRecipes ++ go newState newElf1 newElf2

count :: Int
count = read $ filter (/= '\n') input

part1 :: String
part1 = concatMap show $ take 10 $ drop count recipeSequence

part2 :: Int
part2 = length $ takeWhile (\t -> take (length recipes) t /= recipes) $ tails recipeSequence
