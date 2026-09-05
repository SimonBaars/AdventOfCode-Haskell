import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (group)

input :: String
input = unsafePerformIO $ readInput 2015 10

lookAndSay :: String -> String
lookAndSay = concatMap (\g -> show (length g) ++ [head g]) . group

part1 :: Int
part1 = length $ iterate lookAndSay input !! 40

part2 :: Int
part2 = length $ iterate lookAndSay input !! 50
