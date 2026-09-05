import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.Char (isDigit)

-- Day 18: Operation Order
-- Expression evaluation with custom precedence

input :: [String]
input = unsafePerformIO $ readInputLines 2020 18

-- Part 1: Equal precedence, left-to-right evaluation
part1 :: Int
part1 = sum $ map (eval1 . filter (/= ' ')) input

eval1 :: String -> Int
eval1 = fst . parseExpr1

parseExpr1 :: String -> (Int, String)
parseExpr1 s = 
    let (val, rest) = parseTerm1 s
    in parseOps1 val rest
  where
    parseOps1 val ('+'
:rest) = let (val2, rest2) = parseTerm1 rest in parseOps1 (val + val2) rest2
    parseOps1 val ('*':rest) = let (val2, rest2) = parseTerm1 rest in parseOps1 (val * val2) rest2
    parseOps1 val rest = (val, rest)

parseTerm1 :: String -> (Int, String)
parseTerm1 ('(':rest) = 
    let (val, ')':rest2) = parseExpr1 rest
    in (val, rest2)
parseTerm1 (c:rest) | isDigit c = (read [c], rest)
parseTerm1 _ = error "Invalid term"

-- Part 2: Addition has higher precedence than multiplication
part2 :: Int
part2 = sum $ map (eval2 . filter (/= ' ')) input

eval2 :: String -> Int
eval2 = fst . parseMul2

parseMul2 :: String -> (Int, String)
parseMul2 s = 
    let (val, rest) = parseAdd2 s
    in parseMulOps2 val rest
  where
    parseMulOps2 val ('*':rest) = 
        let (val2, rest2) = parseAdd2 rest
        in parseMulOps2 (val * val2) rest2
    parseMulOps2 val rest = (val, rest)

parseAdd2 :: String -> (Int, String)
parseAdd2 s = 
    let (val, rest) = parseTerm2 s
    in parseAddOps2 val rest
  where
    parseAddOps2 val ('+':rest) = 
        let (val2, rest2) = parseTerm2 rest
        in parseAddOps2 (val + val2) rest2
    parseAddOps2 val rest = (val, rest)

parseTerm2 :: String -> (Int, String)
parseTerm2 ('(':rest) = 
    let (val, ')':rest2) = parseMul2 rest
    in (val, rest2)
parseTerm2 (c:rest) | isDigit c = (read [c], rest)
parseTerm2 _ = error "Invalid term"
