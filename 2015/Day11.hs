import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (group, tails)

input :: String
input = unsafePerformIO $ readInput 2015 11

increment :: String -> String
increment = reverse . inc . reverse
  where
    inc [] = "a"
    inc ('z':xs) = 'a' : inc xs
    inc (x:xs) = succ x : xs

isValid :: String -> Bool
isValid s = hasStraight s && not (hasForbidden s) && hasTwoPairs s

hasStraight :: String -> Bool
hasStraight s = any (\(a:b:c:_) -> succ a == b && succ b == c) (filter ((>= 3) . length) $ tails s)

hasForbidden :: String -> Bool
hasForbidden s = any (`elem` "iol") s

hasTwoPairs :: String -> Bool
hasTwoPairs s = (>= 2) $ length $ filter ((>= 2) . length) $ group s

nextPassword :: String -> String
nextPassword = head . filter isValid . tail . iterate increment

part1 :: String
part1 = nextPassword input

part2 :: String
part2 = nextPassword part1
