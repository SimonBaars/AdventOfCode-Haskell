module Day11 (part1, part2) where

import Control.Monad.State
import Data.List (sort)

data Monkey = Monkey
  { items :: [Integer],
    op :: Integer -> Integer,
    divTest :: Integer,
    ifTrue :: Int,
    ifFalse :: Int,
    inspections :: Integer
  }

splitBlocks :: [String] -> [[String]]
splitBlocks [] = []
splitBlocks ls =
  case break null ls of
    (a, _ : b) -> a : splitBlocks b
    (a, []) -> [a | not (null a)]

parseMonkeys :: String -> [Monkey]
parseMonkeys = map parseBlock . splitBlocks . lines

parseBlock :: [String] -> Monkey
parseBlock ls =
  let itemsLine = ls !! 1
      opLine = ls !! 2
      testLine = ls !! 3
      trueLine = ls !! 4
      falseLine = ls !! 5
      nums s = case dropWhile (/= ':') s of
        ':' : rest -> map read $ splitComma $ trim rest
        _ -> error "Day11: items"
      splitComma = map trim . splitOn ','
      trim = dropWhile (== ' ') . reverse . dropWhile (== ' ') . reverse
      splitOn _ [] = []
      splitOn c s = case break (== c) s of
        (a, _ : b) -> a : splitOn c b
        (a, []) -> [a]
      opFn = parseOp opLine
      d = read $ last $ words testLine
      t = read $ last $ words trueLine
      f = read $ last $ words falseLine
   in Monkey (nums itemsLine) opFn d t f 0

parseOp :: String -> Integer -> Integer
parseOp s = case words s of
  ["Operation:", "new", "=", "old", "*", "old"] -> \x -> x * x
  ["Operation:", "new", "=", "old", "*", n] -> (* read n)
  ["Operation:", "new", "=", "old", "+", n] -> (+ read n)
  _ -> error "Day11: op"

updateMonkey :: Int -> Monkey -> [Monkey] -> [Monkey]
updateMonkey j m' ms = take j ms ++ [m'] ++ drop (j + 1) ms

throwRound :: Bool -> Integer -> State [Monkey] ()
throwRound worryDiv3 modulus = do
  n <- gets length
  forM_ [0 .. n - 1] $ \i -> go i
  where
    go :: Int -> State [Monkey] ()
    go i = do
      ms <- get
      let m = ms !! i
      case items m of
        [] -> pure ()
        (it : rest) -> do
          modify $ updateMonkey i $ m {items = rest, inspections = inspections m + 1}
          let worry = op m it
              worry'
                | worryDiv3 = worry `div` 3
                | otherwise = worry `mod` modulus
              dest = if worry' `mod` divTest m == 0 then ifTrue m else ifFalse m
          modify $ pushItem dest worry'
          go i

    pushItem :: Int -> Integer -> [Monkey] -> [Monkey]
    pushItem j w ms =
      let mj = ms !! j
          mj' = mj {items = items mj ++ [w]}
       in updateMonkey j mj' ms

run :: Int -> Bool -> [Monkey] -> [Monkey]
run rounds p ms0 =
  let modulus = product $ map divTest ms0
   in execState (replicateM_ rounds (throwRound p modulus)) ms0

monkeyBusiness :: [Monkey] -> Integer
monkeyBusiness ms =
  product $ take 2 $ reverse $ sort $ map inspections ms

part1 :: String -> Integer
part1 s = monkeyBusiness $ run 20 True $ parseMonkeys s

part2 :: String -> Integer
part2 s = monkeyBusiness $ run 10000 False $ parseMonkeys s
