import Data.List (nub, isPrefixOf, tails)
import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)

raw :: String
raw = unsafePerformIO $ readInput 2015 19

rules :: [(String,String)]
molecule :: String
(rules, molecule) =
  let ls = lines raw
      (rs, rest) = break null ls
      mol = case rest of
        (_:m:_) -> m
        _ -> error "no molecule"
  in (map parse rs, mol)
  where
    parse line = case words line of
      [a,"=>",b] -> (a,b)
      _ -> error line

replaceAt :: String -> String -> String -> Int -> String
replaceAt mol from to i = take i mol ++ to ++ drop (i + length from) mol

indicesOf :: String -> String -> [Int]
indicesOf mol from = [i | (i,t) <- zip [0..] (tails mol), from `isPrefixOf` t]

part1 :: Int
part1 = length $ nub
  [ replaceAt molecule from to i
  | (from,to) <- rules, i <- indicesOf molecule from ]

part2 :: Int
part2 =
  let elements = length $ filter (`elem` ['A'..'Z']) molecule
      rn = length $ indicesOf molecule "Rn"
      ar = length $ indicesOf molecule "Ar"
      y = length $ indicesOf molecule "Y"
  in elements - rn - ar - 2*y - 1
