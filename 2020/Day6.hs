import Data.List
import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)

input :: [[String]]
input = unsafePerformIO $ parseGroups <$> readInput 2020 6

parseGroups :: String -> [[String]]
parseGroups content = map lines $ splitOn "\n\n" content

splitOn :: String -> String -> [String]
splitOn delimiter str = case breakOn delimiter str of
    (chunk, "") -> [chunk]
    (chunk, rest) -> chunk : splitOn delimiter (drop (length delimiter) rest)

breakOn :: String -> String -> (String, String)
breakOn needle haystack = go [] haystack
  where
    go acc [] = (reverse acc, "")
    go acc s@(c:cs)
        | needle `isPrefixOf` s = (reverse acc, s)
        | otherwise = go (c:acc) cs

part1 :: Int
part1 = sum $ map (length . foldr1 union) input

part2 :: Int
part2 = sum $ map (length . foldr1 intersect) input
