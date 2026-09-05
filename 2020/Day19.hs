import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Map.Strict as Map
import Data.List (isPrefixOf)

-- Day 19: Monster Messages
-- Parse messages against recursive grammar rules

data Rule = Literal Char | Seq [Int] | Or [Int] [Int] deriving (Show)

input :: (Map.Map Int Rule, [String])
input = unsafePerformIO $ parseInput <$> readInput 2020 19

parseInput :: String -> (Map.Map Int Rule, [String])
parseInput s = (rules, messages)
  where
    [rulesBlock, messagesBlock] = splitOn "\n\n" s
    rules = Map.fromList $ map parseRule $ lines rulesBlock
    messages = lines messagesBlock

parseRule :: String -> (Int, Rule)
parseRule line = (ruleNum, rule)
  where
    [numStr, rest] = splitOn ": " line
    ruleNum = read numStr
    rule = if '"' `elem` rest
           then Literal (rest !! 1)
           else if '|' `elem` rest
                then let [left, right] = splitOn " | " rest
                     in Or (map read $ words left) (map read $ words right)
                else Seq (map read $ words rest)

splitOn :: String -> String -> [String]
splitOn delim str = case breakOn delim str of
    (chunk, "") -> [chunk]
    (chunk, rest) -> chunk : splitOn delim (drop (length delim) rest)

breakOn :: String -> String -> (String, String)
breakOn needle haystack = go [] haystack
  where
    go acc [] = (reverse acc, "")
    go acc s@(c:cs)
        | needle `isPrefixOf` s = (reverse acc, s)
        | otherwise = go (c:acc) cs

-- Match a message against a rule
matchRule :: Map.Map Int Rule -> Int -> String -> [String]
matchRule rules ruleId str = case Map.lookup ruleId rules of
    Just (Literal c) -> if not (null str) && head str == c then [tail str] else []
    Just (Seq ruleIds) -> foldl (\strs rid -> concatMap (matchRule rules rid) strs) [str] ruleIds
    Just (Or left right) -> matchRule rules' (-1) str ++ matchRule rules' (-2) str
      where
        rules' = Map.insert (-1) (Seq left) $ Map.insert (-2) (Seq right) rules
    Nothing -> []

part1 :: Int
part1 = length [m | m <- messages, "" `elem` matchRule rules 0 m]
  where (rules, messages) = input

-- Part 2: Update rules 8 and 11 with recursion
part2 :: Int
part2 = length [m | m <- messages, "" `elem` matchRule rules' 0 m]
  where
    (rules, messages) = input
    rules' = Map.insert 8 (Or [42] [42, 8]) $
             Map.insert 11 (Or [42, 31] [42, 11, 31]) rules
