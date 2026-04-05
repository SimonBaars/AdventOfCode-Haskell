module Day03 (part1, part2) where

import Data.Char (ord)
import qualified Data.Set as Set

priority :: Char -> Int
priority c
  | c >= 'a' && c <= 'z' = ord c - ord 'a' + 1
  | otherwise = ord c - ord 'A' + 27

splitHalf :: String -> (String, String)
splitHalf s =
  let n = length s `div` 2
   in (take n s, drop n s)

commonChar :: String -> String -> Char
commonChar a b =
  head $ Set.toList $ Set.intersection (Set.fromList a) (Set.fromList b)

badge :: [String] -> Char
badge [a, b, c] =
  head $
    Set.toList $
      Set.intersection (Set.fromList a) $
        Set.intersection (Set.fromList b) (Set.fromList c)
badge _ = error "Day03: need 3 lines"

part1 :: String -> Int
part1 =
  sum
    . map (priority . uncurry commonChar . splitHalf)
    . lines

part2 :: String -> Int
part2 =
  sum
    . map (priority . badge)
    . chunksOf3
    . lines

chunksOf3 :: [a] -> [[a]]
chunksOf3 (a : b : c : xs) = [a, b, c] : chunksOf3 xs
chunksOf3 [] = []
chunksOf3 _ = error "Day03: line count not multiple of 3"
