import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.Char (isDigit)

input :: [String]
input = unsafePerformIO $ readInputLines 2020 18

part1 :: Int
part1 = sum $ map (eval1 . filter (/= ' ')) input

eval1 :: String -> Int
eval1 = fst . parseExpr1

parseExpr1 :: String -> (Int, String)
parseExpr1 s =
    let (val, rest) = parseTerm1 s
    in parseOps1 val rest

parseOps1 :: Int -> String -> (Int, String)
parseOps1 val ('+':rest) = let (val2, rest2) = parseTerm1 rest in parseOps1 (val + val2) rest2
parseOps1 val ('*':rest) = let (val2, rest2) = parseTerm1 rest in parseOps1 (val * val2) rest2
parseOps1 val rest = (val, rest)

parseTerm1 :: String -> (Int, String)
parseTerm1 ('(':rest) =
    let (val, rest') = parseExpr1 rest
    in case rest' of
        (')':rest2) -> (val, rest2)
        _ -> error "missing )"
parseTerm1 (c:rest) | isDigit c = (read [c], rest)
parseTerm1 _ = error "Invalid term"

part2 :: Int
part2 = sum $ map (eval2 . filter (/= ' ')) input

eval2 :: String -> Int
eval2 = fst . parseMul2

parseMul2 :: String -> (Int, String)
parseMul2 s =
    let (val, rest) = parseAdd2 s
    in parseMulOps2 val rest

parseMulOps2 :: Int -> String -> (Int, String)
parseMulOps2 val ('*':rest) =
    let (val2, rest2) = parseAdd2 rest
    in parseMulOps2 (val * val2) rest2
parseMulOps2 val rest = (val, rest)

parseAdd2 :: String -> (Int, String)
parseAdd2 s =
    let (val, rest) = parseTerm2 s
    in parseAddOps2 val rest

parseAddOps2 :: Int -> String -> (Int, String)
parseAddOps2 val ('+':rest) =
    let (val2, rest2) = parseTerm2 rest
    in parseAddOps2 (val + val2) rest2
parseAddOps2 val rest = (val, rest)

parseTerm2 :: String -> (Int, String)
parseTerm2 ('(':rest) =
    let (val, rest') = parseMul2 rest
    in case rest' of
        (')':rest2) -> (val, rest2)
        _ -> error "missing )"
parseTerm2 (c:rest) | isDigit c = (read [c], rest)
parseTerm2 _ = error "Invalid term"
