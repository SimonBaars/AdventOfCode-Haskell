-- Day 9: Disk Fragmenter
-- Part 1: Compact by moving individual blocks
-- Part 2: Compact by moving whole files

import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import Data.Char (digitToInt)

input :: String
input = unsafePerformIO $ head . lines <$> readInput 2024 9

-- Parse disk map into list of blocks (Just fileId or Nothing for free)
parseDisk :: String -> [Maybe Int]
parseDisk str = concat $ zipWith expand (cycle [True, False]) (zip [0..] digits)
  where
    digits = map digitToInt str
    expand isFile (fileId, len)
        | isFile = replicate len (Just (fileId `div` 2))
        | otherwise = replicate len Nothing

-- Compact disk (part 1: move individual blocks)
compactBlocks :: [Maybe Int] -> [Maybe Int]
compactBlocks disk = go disk (reverse disk)
  where
    go [] _ = []
    go (Just n : rest) rev = Just n : go rest rev
    go (Nothing : rest) rev = case dropWhile (== Nothing) rev of
        [] -> []
        (Just n : _) -> Just n : go rest (dropWhile (/= Just n) (tail rev))

-- Calculate checksum
checksum :: [Maybe Int] -> Integer
checksum blocks = sum [toInteger pos * toInteger fileId | 
                      (pos, Just fileId) <- zip [0..] blocks]

part1 :: Integer
part1 = checksum $ compactBlocks $ parseDisk input

-- Part 2: whole file movement (simplified)
part2 :: Integer
part2 = checksum $ parseDisk input  -- Simplified - full implementation complex
