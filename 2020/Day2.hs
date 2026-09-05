import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

type Password = ((Int, Int), Char, String)

input :: [Password]
input = unsafePerformIO $ map parseLine <$> readInputLines 2020 2

parseLine :: String -> Password
parseLine line = ((read minStr, read maxStr), head charStr, password)
  where
    [range, charWithColon, password] = words line
    [minStr, maxStr] = splitOn '-' range
    charStr = take 1 charWithColon

splitOn :: Char -> String -> [String]
splitOn c s = case break (== c) s of
    (a, []) -> [a]
    (a, _:b) -> a : splitOn c b

part1 :: Int
part1 = length $ filter validate1 input

validate1 :: Password -> Bool
validate1 ((l, h), c, s) = let n = count c s in n >= l && n <= h

validate2 :: Password -> Bool
validate2 ((l, h), c, s) = c1 /= c2 && (c1 == c || c2 == c)
  where c1 = s !! (l-1)
        c2 = s !! (h-1)

count :: Eq a => a -> [a] -> Int
count a = length . filter (a==)

part2 :: Int
part2 = length $ filter validate2 input
