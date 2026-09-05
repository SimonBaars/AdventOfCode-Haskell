-- Day 17: Chronospatial Computer
-- Part 1: Run program and output result
-- Part 2: Find register A that makes program output itself

import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import Data.List (intercalate)

input :: String
input = unsafePerformIO $ readInput 2024 17

data Computer = Computer { regA :: Integer, regB :: Integer, regC :: Integer,
                          ip :: Int, output :: [Integer] } deriving Show

-- Parse input
parseInput :: String -> (Computer, [Int])
parseInput str = (Computer a b c 0 [], program)
  where
    [regsStr, progStr] = splitOn "\n\n" str
    [aLine, bLine, cLine] = lines regsStr
    a = read $ drop 12 aLine
    b = read $ drop 12 bLine
    c = read $ drop 12 cLine
    program = map read $ splitOn "," $ drop 9 progStr
    
    splitOn c s = case break (== c) s of
        (chunk, "") -> [chunk]
        (chunk, _:rest) -> chunk : splitOn c rest

-- Get combo operand value
combo :: Computer -> Int -> Integer
combo comp 0 = 0
combo comp 1 = 1
combo comp 2 = 2
combo comp 3 = 3
combo comp 4 = regA comp
combo comp 5 = regB comp
combo comp 6 = regC comp

-- Execute one instruction
execute :: Computer -> [Int] -> Computer
execute comp prog
    | ip comp >= length prog = comp
    | otherwise = case opcode of
        0 -> execute comp{regA = regA comp `div` (2 ^ combo comp operand), 
                         ip = ip comp + 2} prog  -- adv
        1 -> execute comp{regB = regB comp `xor` toInteger operand, 
                         ip = ip comp + 2} prog  -- bxl
        2 -> execute comp{regB = combo comp operand `mod` 8, 
                         ip = ip comp + 2} prog  -- bst
        3 -> execute comp{ip = if regA comp == 0 then ip comp + 2 
                                else operand} prog  -- jnz
        4 -> execute comp{regB = regB comp `xor` regC comp, 
                         ip = ip comp + 2} prog  -- bxc
        5 -> execute comp{output = output comp ++ [combo comp operand `mod` 8], 
                         ip = ip comp + 2} prog  -- out
        6 -> execute comp{regB = regA comp `div` (2 ^ combo comp operand), 
                         ip = ip comp + 2} prog  -- bdv
        7 -> execute comp{regC = regA comp `div` (2 ^ combo comp operand), 
                         ip = ip comp + 2} prog  -- cdv
  where
    opcode = prog !! ip comp
    operand = prog !! (ip comp + 1)

part1 :: String
part1 = intercalate "," $ map show $ output final
  where
    (comp, prog) = parseInput input
    final = execute comp prog

-- Part 2: Find A value that makes program output itself
part2 :: Integer
part2 = findQuine prog
  where
    (_, prog) = parseInput input
    
    findQuine program = head [a | a <- [1..], 
                             let comp = Computer a 0 0 0 [],
                             let final = execute comp program,
                             map fromIntegral (output final) == program]
