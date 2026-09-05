import Data.List (tails)
import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)

input :: String
input = unsafePerformIO $ readInput 2015 11

inc :: String -> String
inc = reverse . go . reverse
  where
    go [] = "a"
    go ('z':xs) = 'a' : go xs
    go (c:xs) = succ c : xs

hasStraight :: String -> Bool
hasStraight s = any (\(a:b:c:_) -> succ a==b && succ b==c) [t | t@( _: _: _: _) <- tails s]

noForbidden :: String -> Bool
noForbidden s = not $ any (`elem` s) "iol"

pairs :: String -> Int
pairs = go Nothing
  where
    go _ [] = 0
    go _ [_] = 0
    go prev (a:b:xs)
      | a==b && Just a /= prev = 1 + go (Just a) xs
      | otherwise = go prev (b:xs)

valid :: String -> Bool
valid s = hasStraight s && noForbidden s && pairs s >= 2

nextValid :: String -> String
nextValid = head . filter valid . iterate inc . inc

part1 :: String
part1 = nextValid input

part2 :: String
part2 = nextValid part1
