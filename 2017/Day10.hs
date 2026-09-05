import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import Data.Char (ord)
import Data.Bits (xor)
import Data.List (foldl')
import Numeric (showHex)

input :: String
input = unsafePerformIO $ readInput 2017 10

lengths1 :: [Int]
lengths1 = map read $ words $ map (\c -> if c == ',' then ' ' else c) $ filter (/= '\n') input

lengths2 :: [Int]
lengths2 = map ord (filter (/= '\n') input) ++ [17, 31, 73, 47, 23]

knotHash :: Int -> [Int] -> [Int] -> (Int, Int, [Int])
knotHash rounds lengths list = go rounds 0 0 list
  where
    go 0 pos skip lst = (pos, skip, lst)
    go r pos skip lst =
        let (pos', skip', lst') = foldl' step (pos, skip, lst) lengths
        in go (r - 1) pos' skip' lst'
    
    step (pos, skip, lst) len =
        let lst' = reverse' pos len lst
            pos' = (pos + len + skip) `mod` length lst
            skip' = skip + 1
        in (pos', skip', lst')
    
    reverse' start len lst =
        let indices = [start + i `mod` length lst | i <- [0..len-1]]
            values = [lst !! i | i <- indices]
            revValues = reverse values
        in [if i `elem` indices then revValues !! (head [j | (j, idx) <- zip [0..] indices, idx == i]) else lst !! i | i <- [0..length lst - 1]]

denseHash :: [Int] -> [Int]
denseHash sparse = [foldl1 xor (take 16 $ drop (i * 16) sparse) | i <- [0..15]]

hexHash :: [Int] -> String
hexHash = concatMap (\n -> if n < 16 then '0' : showHex n "" else showHex n "")

part1 :: Int
part1 = let (_, _, lst) = knotHash 1 lengths1 [0..255] in lst !! 0 * lst !! 1

part2 :: String
part2 = hexHash $ denseHash $ (\(_, _, lst) -> lst) $ knotHash 64 lengths2 [0..255]
