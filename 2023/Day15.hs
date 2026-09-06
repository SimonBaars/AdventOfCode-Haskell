-- Day 15: Lens Library
-- Part 1: Sum of HASH values
-- Part 2: Lens focusing power

import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import Data.Char (ord)
import qualified Data.Map as M
import Data.List (elemIndex)

input :: String
input = unsafePerformIO $ readInput 2023 15

-- HASH algorithm
hash :: String -> Int
hash = foldl (\acc c -> ((acc + ord c) * 17) `mod` 256) 0

-- Parse instructions
parseInstructions :: String -> [String]
parseInstructions = splitOn ','
  where
    splitOn c str = case break (== c) str of
        (chunk, "") -> [chunk]
        (chunk, _:rest) -> chunk : splitOn c rest

-- Process instructions for part 2
type Box = [(String, Int)]  -- List of (label, focal length) pairs
type Boxes = M.Map Int Box

processInstruction :: Boxes -> String -> Boxes
processInstruction boxes instr
    | '-' `elem` instr = M.adjust (filter (\(l, _) -> l /= label)) boxNum boxes
    | otherwise = M.alter (Just . updateBox) boxNum boxes
  where
    label = takeWhile (/= '=') $ takeWhile (/= '-') instr
    boxNum = hash label
    focalLen = read $ drop 1 $ dropWhile (/= '=') instr :: Int
    
    updateBox Nothing = [(label, focalLen)]
    updateBox (Just lenses) = 
        case elemIndex label (map fst lenses) of
            Just idx -> take idx lenses ++ [(label, focalLen)] ++ drop (idx + 1) lenses
            Nothing -> lenses ++ [(label, focalLen)]

-- Calculate focusing power
focusingPower :: Boxes -> Int
focusingPower boxes = sum [
    (boxNum + 1) * (slot + 1) * focal |
    (boxNum, lenses) <- M.toList boxes,
    (slot, (_, focal)) <- zip [0..] lenses]

part1 :: Int
part1 = sum $ map hash $ parseInstructions $ head $ lines input

part2 :: Int
part2 = focusingPower $ foldl processInstruction M.empty $ parseInstructions $ head $ lines input
