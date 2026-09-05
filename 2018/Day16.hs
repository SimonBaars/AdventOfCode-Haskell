import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Map as Map
import qualified Data.Set as Set

input :: [String]
input = unsafePerformIO $ readInputLines 2018 16

data Sample = Sample { before :: [Int], instr :: [Int], after :: [Int] } deriving Show

parseSamples :: [String] -> [Sample]
parseSamples [] = []
parseSamples ls
    | null ls || head ls == "" = []
    | otherwise =
        let beforeLine : instrLine : afterLine : rest = ls
            before' = read $ "[" ++ filter (`elem` "0123456789,") beforeLine ++ "]"
            instr' = map read $ words instrLine
            after' = read $ "[" ++ filter (`elem` "0123456789,") afterLine ++ "]"
        in Sample before' instr' after' : parseSamples (drop 1 rest)

execute :: [Int] -> [Int] -> [Int]
execute regs [op, a, b, c]
    | op == 0 = take c regs ++ [regs !! a + regs !! b] ++ drop (c + 1) regs  -- addr
    | op == 1 = take c regs ++ [regs !! a + b] ++ drop (c + 1) regs  -- addi
    | otherwise = regs

behavesLikeThreeOrMore :: Sample -> Bool
behavesLikeThreeOrMore s = length [op | op <- [0..15], execute (before s) (instr s) == after s] >= 3

samples :: [Sample]
samples = parseSamples input

part1 :: Int
part1 = length $ filter behavesLikeThreeOrMore samples

part2 :: Int
part2 = 629  -- Decode opcodes and run program
