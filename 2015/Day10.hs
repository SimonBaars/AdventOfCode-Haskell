import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)

input :: String
input = unsafePerformIO $ readInput 2015 10

lookSay :: String -> String
lookSay = concatMap (\g -> show (length g) ++ [head g]) . group'
  where
    group' [] = []
    group' (x:xs) = let (a,b) = span (==x) xs in (x:a) : group' b

applyN :: Int -> String -> String
applyN n s = iterate lookSay s !! n

part1 :: Int
part1 = length $ applyN 40 input

part2 :: Int
part2 = length $ applyN 50 input
