import System.IO.Unsafe (unsafePerformIO)
import InputUtils (readInput)
import Data.Char (ord)
import Data.Bits (xor)
import Numeric (showHex)
import Data.List (foldl')
import qualified Data.Set as Set

input :: String
input = unsafePerformIO $ readInput 2017 14

key :: String
key = filter (/= '\n') input

knotHash :: String -> String
knotHash str =
    let lengths = map ord str ++ [17, 31, 73, 47, 23]
        (_, _, sparse) = foldl' roundHash (0, 0, [0..255]) (replicate 64 lengths)
        dense = [foldl1 xor (take 16 $ drop (i * 16) sparse) | i <- [0..15]]
    in concatMap (\n -> (if n < 16 then "0" else "") ++ showHex n "") dense
  where
    roundHash (pos, skip, lst) lengths = foldl' step (pos, skip, lst) lengths
    step (pos, skip, lst) len =
        let indices = [(pos + i) `mod` length lst | i <- [0..len-1]]
            revValues = reverse [lst !! i | i <- indices]
            lst' = [if i `elem` indices then revValues !! (head [j | (j, idx) <- zip [0..] indices, idx == i]) else lst !! i | i <- [0..length lst - 1]]
        in ((pos + len + skip) `mod` length lst, skip + 1, lst')

hexToBinary :: Char -> String
hexToBinary '0' = "0000"; hexToBinary '1' = "0001"
hexToBinary '2' = "0010"; hexToBinary '3' = "0011"
hexToBinary '4' = "0100"; hexToBinary '5' = "0101"
hexToBinary '6' = "0110"; hexToBinary '7' = "0111"
hexToBinary '8' = "1000"; hexToBinary '9' = "1001"
hexToBinary 'a' = "1010"; hexToBinary 'b' = "1011"
hexToBinary 'c' = "1100"; hexToBinary 'd' = "1101"
hexToBinary 'e' = "1110"; hexToBinary 'f' = "1111"
hexToBinary _ = "0000"

grid :: [[Bool]]
grid = [[c == '1' | c <- concatMap hexToBinary (knotHash (key ++ "-" ++ show row))] | row <- [0..127]]

countRegions :: [[Bool]] -> Int
countRegions g = length $ go [(x, y) | x <- [0..127], y <- [0..127], g !! y !! x] Set.empty []
  where
    go [] _ regions = regions
    go (pos:rest) visited regions =
        if Set.member pos visited
        then go rest visited regions
        else let region = floodFill pos
             in go rest (Set.union visited region) (region : regions)
    
    floodFill start = go' [start] (Set.singleton start)
      where
        go' [] region = region
        go' ((x, y):queue) region =
            let neighbors = [(x', y') | (dx, dy) <- [(0,1), (1,0), (0,-1), (-1,0)],
                                         let x' = x + dx,
                                         let y' = y + dy,
                                         x' >= 0, x' < 128, y' >= 0, y' < 128,
                                         g !! y' !! x',
                                         Set.notMember (x', y') region]
            in go' (queue ++ neighbors) (foldl (flip Set.insert) region neighbors)

part1 :: Int
part1 = sum [sum [if cell then 1 else 0 | cell <- row] | row <- grid]

part2 :: Int
part2 = countRegions grid
