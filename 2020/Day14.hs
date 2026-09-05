import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Map as Map
import Data.Char (digitToInt)
import Data.Bits (setBit, clearBit, testBit)

-- Day 14: Docking Data
-- Bitmask operations on memory

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

-- Part 1: Apply mask to values
part1 :: Int
part1 = sum $ Map.elems $ foldl execute1 Map.empty input
  where
    execute1 (mem, _) (Mask m) = (mem, m)
    execute1 (mem, mask) (Mem addr val) = (Map.insert addr (applyMask1 mask val) mem, mask)

applyMask1 :: String -> Int -> Int
applyMask1 mask val = foldl applyBit val (zip [35,34..0] mask)
  where
    applyBit v (pos, '0') = clearBit v pos
    applyBit v (pos, '1') = setBit v pos
    applyBit v _ = v

-- Part 2: Apply mask to addresses with floating bits
part2 :: Int
part2 = sum $ Map.elems $ foldl execute2 Map.empty input
  where
    execute2 (mem, _) (Mask m) = (mem, m)
    execute2 (mem, mask) (Mem addr val) = 
        (foldr (\a m -> Map.insert a val m) mem (generateAddrs mask addr), mask)

generateAddrs :: String -> Int -> [Int]
generateAddrs mask addr = [applyMask2 mask addr bits | bits <- generateBits xCount]
  where
    xCount = length $ filter (== 'X') mask
    generateBits n = [[testBit i b | b <- [0..n-1]] | i <- [0..2^n-1]]

applyMask2 :: String -> Int -> [Bool] -> Int
applyMask2 mask addr floatingBits = foldl applyBit addr (zip3 [35,34..0] mask floatingBits')
  where
    floatingBits' = floatingBits ++ repeat False
    applyBit v (pos, '1', _) = setBit v pos
    applyBit v (pos, 'X', True) = setBit v pos
    applyBit v (pos, 'X', False) = clearBit v pos
    applyBit v _ = v
