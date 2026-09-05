import Data.List
import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [String]
input = unsafePerformIO $ readInputLines 2020 5

part1 :: Integer
part1 = maximum getSeatIds

part2 :: Integer
part2 = head [id+1 | id <- ids, id `elem` ids, (id+1) `notElem` ids, (id+2) `elem` ids]
      where ids = getSeatIds

getSeatIds :: [Integer]
getSeatIds = [r * 8 + c | (r, c) <- map getRowAndColumn input]

getRowAndColumn :: String -> (Integer, Integer)
getRowAndColumn = rowAndColumn 0 127 0 7

rowAndColumn :: Integer -> Integer -> Integer -> Integer -> String -> (Integer, Integer)
rowAndColumn rowLow rowHigh colLow colHigh ('B':xs) = rowAndColumn (rowLow+((rowHigh-rowLow+1) `div` 2)) rowHigh colLow colHigh xs
rowAndColumn rowLow rowHigh colLow colHigh ('F':xs) = rowAndColumn rowLow (rowHigh-((rowHigh-rowLow+1) `div` 2)) colLow colHigh xs
rowAndColumn rowLow rowHigh colLow colHigh ('L':xs) = rowAndColumn rowLow rowHigh colLow (colHigh-((colHigh-colLow+1) `div` 2)) xs
rowAndColumn rowLow rowHigh colLow colHigh ('R':xs) = rowAndColumn rowLow rowHigh (colLow+((colHigh-colLow+1) `div` 2)) colHigh xs
rowAndColumn _ r _ c [] = (r, c)
