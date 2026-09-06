-- Day 5: Supply Stacks
-- Part 1: Move crates one at a time (reversing order)
-- Part 2: Move multiple crates at once (preserving order)

import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (transpose)
import Data.Char (isDigit, isAlpha)
import qualified Data.Map as M

type Stacks = M.Map Int [Char]
type Move = (Int, Int, Int)  -- (count, from, to)

input :: (Stacks, [Move])
input = unsafePerformIO $ do
    content <- readInput 2022 5
    let [stacksStr, movesStr] = splitOn "\n\n" content
    return (parseStacks stacksStr, parseMoves movesStr)
  where
    splitOn :: String -> String -> [String]
    splitOn delim str = case breakOn delim str of
        (chunk, "") -> [chunk]
        (chunk, rest) -> chunk : splitOn delim (drop (length delim) rest)
    
    breakOn :: String -> String -> (String, String)
    breakOn delim str = go [] str
      where
        go acc s
            | take (length delim) s == delim = (reverse acc, s)
            | null s = (reverse acc, "")
            | otherwise = go (head s : acc) (tail s)

parseStacks :: String -> Stacks
parseStacks str = M.fromList $ zip [1..] columns
  where
    rows = lines str
    dataRows = init rows  -- Remove the number row
    -- Extract characters at positions 1, 5, 9, 13, etc.
    columns = [filter isAlpha [row !! i | row <- dataRows, i < length row]
              | i <- [1, 5..maximum (map length dataRows)]]

parseMoves :: String -> [Move]
parseMoves str = [parseMove line | line <- lines str]
  where
    parseMove line = (count, from, to)
      where
        words' = words line
        count = read (words' !! 1)
        from = read (words' !! 3)
        to = read (words' !! 5)

-- Move crates one at a time (Part 1)
applyMove1 :: Stacks -> Move -> Stacks
applyMove1 stacks (count, from, to) = iterate moveSingle stacks !! count
  where
    moveSingle st = 
        let fromStack = st M.! from
            toStack = st M.! to
            crate = head fromStack
        in M.insert from (tail fromStack) $ M.insert to (crate : toStack) st

-- Move multiple crates at once (Part 2)
applyMove2 :: Stacks -> Move -> Stacks
applyMove2 stacks (count, from, to) =
    let fromStack = stacks M.! from
        toStack = stacks M.! to
        crates = take count fromStack
    in M.insert from (drop count fromStack) $ M.insert to (crates ++ toStack) stacks

-- Get the top crate from each stack
getTops :: Stacks -> String
getTops stacks = [head (stacks M.! i) | i <- [1..M.size stacks]]

part1 :: String
part1 = getTops $ foldl applyMove1 stacks moves
  where (stacks, moves) = input

part2 :: String
part2 = getTops $ foldl applyMove2 stacks moves
  where (stacks, moves) = input
