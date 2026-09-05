import Data.List (nub, permutations)
import qualified Data.Map.Strict as M
import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [String]
input = unsafePerformIO $ readInputLines 2015 13

parse :: String -> ((String,String), Int)
parse line =
  let ws = words line
      a = head ws
      b = init (last ws)
      sign = if ws!!2 == "gain" then 1 else -1
      n = read (ws!!3) :: Int
  in ((a,b), sign * n)

happiness :: M.Map (String,String) Int
happiness = M.fromList $ map parse input

people :: [String]
people = nub $ concatMap (\(a,b) -> [a,b]) $ M.keys happiness

hap :: String -> String -> Int
hap a b = M.findWithDefault 0 (a,b) happiness

score :: [String] -> Int
score ps =
  let circle = ps ++ [head ps]
  in sum [ hap a b + hap b a | (a,b) <- zip circle (tail circle) ]

best :: [String] -> Int
best ps = maximum $ map score $ map (head ps :) $ permutations (tail ps)

part1 :: Int
part1 = best people

part2 :: Int
part2 = best ("Me" : people)
