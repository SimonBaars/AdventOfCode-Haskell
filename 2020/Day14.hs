import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Map as Map
import Data.Bits (setBit, clearBit)

-- Day 14: Docking Data

data Instruction = Mask String | Mem Int Int deriving (Show)

input :: [Instruction]
input = unsafePerformIO $ map parseInstruction <$> readInputLines 2020 14

parseInstruction :: String -> Instruction
parseInstruction line
    | take 4 line == "mask" = Mask (drop 7 line)
    | otherwise = Mem addr val
  where
    addr = read $ takeWhile (/= ']') $ drop 4 line
    val = read $ drop 1 $ dropWhile (/= '=') line

part1 :: Int
part1 = sum $ Map.elems $ fst $ foldl execute1 (Map.empty, replicate 36 'X') input
  where
    execute1 (mem, _) (Mask m) = (mem, m)
    execute1 (mem, mask) (Mem addr val) = (Map.insert addr (applyMask1 mask val) mem, mask)

applyMask1 :: String -> Int -> Int
applyMask1 mask val = foldl applyBit val (zip [35,34..0] mask)
  where
    applyBit v (pos, '0') = clearBit v pos
    applyBit v (pos, '1') = setBit v pos
    applyBit v _ = v

part2 :: Int
part2 = sum $ Map.elems $ fst $ foldl execute2 (Map.empty, replicate 36 'X') input
  where
    execute2 (mem, _) (Mask m) = (mem, m)
    execute2 (mem, mask) (Mem addr val) =
        (foldr (\a m -> Map.insert a val m) mem (generateAddrs mask addr), mask)

generateAddrs :: String -> Int -> [Int]
generateAddrs mask addr = map (applyMask2 mask addr) (generateBits xCount)
  where
    xCount = length $ filter (== 'X') mask
    generateBits n = [[testBit' i b | b <- [0..n-1]] | i <- [0..(2^n)-1]]
    testBit' i b = (i `div` (2^b)) `mod` 2 == 1

applyMask2 :: String -> Int -> [Bool] -> Int
applyMask2 mask addr floatingBits = go 0 (zip [35,34..0] mask) floatingBits
  where
    go v [] _ = v
    go v ((pos, '0'):rest) bits = go (if testBitOrig addr pos then setBit v pos else clearBit v pos) rest bits
    go v ((pos, '1'):rest) bits = go (setBit v pos) rest bits
    go v ((pos, 'X'):rest) (b:bits) = go (if b then setBit v pos else clearBit v pos) rest bits
    go v ((pos, 'X'):rest) [] = go (clearBit v pos) rest []
    go v (_:rest) bits = go v rest bits
    testBitOrig n pos = (n `div` (2^pos)) `mod` 2 == 1
