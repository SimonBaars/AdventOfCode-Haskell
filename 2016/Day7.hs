import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (isInfixOf)

input :: [String]
input = unsafePerformIO $ readInputLines 2016 7

splitByBrackets :: String -> ([String], [String])
splitByBrackets str = go str "" [] [] False
  where
    go [] current outside inside False = (reverse (reverse current : outside), reverse inside)
    go [] current outside inside True = (reverse outside, reverse (reverse current : inside))
    go ('[':rest) current outside inside False = 
        go rest "" outside (if null current then inside else reverse current : inside) True
    go (']':rest) current outside inside True = 
        go rest "" (reverse current : outside) inside False
    go (c:rest) current outside inside inBracket = 
        go rest (c:current) outside inside inBracket

hasABBA :: String -> Bool
hasABBA (a:b:c:d:rest)
    | a /= b && a == d && b == c = True
    | otherwise = hasABBA (b:c:d:rest)
hasABBA _ = False

supportsTLS :: String -> Bool
supportsTLS str = any hasABBA outside && not (any hasABBA inside)
  where (outside, inside) = splitByBrackets str

getABAs :: String -> [String]
getABAs (a:b:c:rest)
    | a /= b && a == c = [a,b,c] : getABAs (b:c:rest)
    | otherwise = getABAs (b:c:rest)
getABAs _ = []

abaToBAB :: String -> String
abaToBAB [a,b,_] = [b,a,b]
abaToBAB s = s

supportsSSL :: String -> Bool
supportsSSL str = any (\aba -> any (isInfixOf (abaToBAB aba)) inside) allABAs
  where 
    (outside, inside) = splitByBrackets str
    allABAs = concatMap getABAs outside

part1 :: Int
part1 = length $ filter supportsTLS input

part2 :: Int
part2 = length $ filter supportsSSL input
