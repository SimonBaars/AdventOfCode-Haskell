import Text.Regex
import Data.List
import Data.Maybe
import qualified Data.Map as Map
import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)

input :: [[(String, String)]]
input = unsafePerformIO $ parsePassports <$> readInput 2020 4

parsePassports :: String -> [[(String, String)]]
parsePassports content = map parsePassport (splitOn "\n\n" content)

parsePassport :: String -> [(String, String)]
parsePassport passport = map parseField (words (map (\c -> if c == '\n' then ' ' else c) passport))

parseField :: String -> (String, String)
parseField field = case break (== ':') field of
    (key, ':':value) -> (key, value)
    _ -> ("", "")

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

expected :: [(String, String)]
expected = [("byr", "^(200[0-2]|19[2-9][0-9])$"), ("iyr", "^(2020|201[0-9])$"), ("eyr", "^(2030|202[0-9])$"), ("hgt", "^((1([5-8][0-9]|9[0-3])cm)|((59|6[0-9]|7[0-6])in))$"), ("hcl", "^(#[0-9a-f]{6})$"), ("ecl", "^(amb|blu|brn|gry|grn|hzl|oth)$"), ("pid", "^[0-9]{9}$")]

part1 :: Int
part1 = length $ filter verify1 input

part2 :: Int
part2 = length (filter verify2 input)

verify1 :: [(String, String)] -> Bool
verify1 i = all (`elem` map fst i) (map fst expected)

verify2 :: [(String, String)] -> Bool
verify2 i = verify1 i && all (\(key, regex) -> isJust $ matchRegex (mkRegex regex) (fromJust $ Map.lookup key inputMap)) expected
              where inputMap = Map.fromList i
