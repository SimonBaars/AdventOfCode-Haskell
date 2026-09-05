import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (isPrefixOf, find)
import qualified Data.Map.Strict as Map
import qualified Data.Set as Set

-- Day 16: Ticket Translation
-- Validate ticket fields and determine field positions

type Rule = (String, [(Int, Int)])
type Ticket = [Int]

input :: ([Rule], Ticket, [Ticket])
input = unsafePerformIO $ parseInput <$> readInput 2020 16

parseInput :: String -> ([Rule], Ticket, [Ticket])
parseInput s = (rules, myTicket, nearbyTickets)
  where
    [rulesBlock, myTicketBlock, nearbyBlock] = splitOn "\n\n" s
    rules = map parseRule $ lines rulesBlock
    myTicket = parseTicket $ lines myTicketBlock !! 1
    nearbyTickets = map parseTicket $ tail $ lines nearbyBlock

parseRule :: String -> Rule
parseRule line = (name, ranges)
  where
    (name, rest) = breakOn ": " line
    rangesStr = drop 2 rest
    ranges = map parseRange $ splitOn " or " rangesStr
    parseRange r = let [a, b] = splitOn "-" r in (read a, read b)

parseTicket :: String -> Ticket
parseTicket = map read . splitOn ","

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

-- Part 1: Find scanning error rate (sum of invalid values)
part1 :: Int
part1 = sum [val | ticket <- nearbyTickets, val <- ticket, not $ isValidValue val rules]
  where
    (rules, _, nearbyTickets) = input

isValidValue :: Int -> [Rule] -> Bool
isValidValue val rules = any (\(_, ranges) -> any (\(lo, hi) -> val >= lo && val <= hi) ranges) rules

-- Part 2: Determine field positions and multiply departure fields
part2 :: Int
part2 = product [myTicket !! idx | (name, idx) <- Map.toList fieldMap, "departure" `isPrefixOf` name]
  where
    (rules, myTicket, nearbyTickets) = input
    validTickets = filter (\t -> all (`isValidValue` rules) t) nearbyTickets
    fieldMap = solveFieldPositions rules validTickets

solveFieldPositions :: [Rule] -> [Ticket] -> Map.Map String Int
solveFieldPositions rules tickets = solve Map.empty possibilities
  where
    numFields = length (head tickets)
    columns = [[ticket !! i | ticket <- tickets] | i <- [0..numFields-1]]
    possibilities = Map.fromList [(name, Set.fromList [i | (i, col) <- zip [0..] columns, 
                                                           all (\v -> isValidForRule v ranges) col])
                                 | (name, ranges) <- rules]
    
    isValidForRule val ranges = any (\(lo, hi) -> val >= lo && val <= hi) ranges
    
    solve :: Map.Map String Int -> Map.Map String (Set.Set Int) -> Map.Map String Int
    solve found remaining
        | Map.null remaining = found
        | otherwise = case find (\(_, s) -> Set.size s == 1) (Map.toList remaining) of
            Just (name, positions) -> 
                let pos = Set.findMin positions
                    found' = Map.insert name pos found
                    remaining' = Map.map (Set.delete pos) $ Map.delete name remaining
                in solve found' remaining'
            Nothing -> error "No unique position found"
