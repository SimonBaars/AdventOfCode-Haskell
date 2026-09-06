import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)

input :: String
input = unsafePerformIO $ readInput 2018 5

react :: String -> String
react = go []
  where
    go acc [] = reverse acc
    go [] (c:cs) = go [c] cs
    go (a:as) (c:cs)
        | a /= c && (toUpper a == c || a == toUpper c) = go as cs
        | otherwise = go (c:a:as) cs
    toUpper ch = if ch >= 'a' && ch <= 'z' then toEnum (fromEnum ch - 32) else ch

polymer :: String
polymer = filter (/= '\n') input

part1 :: Int
part1 = length $ react polymer

part2 :: Int
part2 = minimum [length $ react $ filter (\c -> c /= unit && c /= toEnum (fromEnum unit + 32)) polymer | unit <- ['A'..'Z']]
  where toEnum = Prelude.toEnum
