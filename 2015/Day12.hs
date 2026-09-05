import Data.Char (isDigit)
import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)

input :: String
input = unsafePerformIO $ readInput 2015 12

-- Part1: sum all integers via regex-like scan
sumNums :: String -> Int
sumNums = sum . map read . words . map (\c -> if c=='-' || isDigit c then c else ' ')

-- Simple JSON value parser for part2
data J = JNum Int | JStr String | JArr [J] | JObj [(String,J)] deriving Show

parseJ :: String -> (J, String)
parseJ s@(c:_)
  | c == '[' = let (xs, r) = parseArr (tail s) in (JArr xs, r)
  | c == '{' = let (xs, r) = parseObj (tail s) in (JObj xs, r)
  | c == '"' = let (str, r) = parseStr (tail s) in (JStr str, r)
  | c == '-' || isDigit c =
      let (n,r) = span (\x -> isDigit x || x=='-') s in (JNum (read n), r)
  | otherwise = error $ "parseJ: " ++ take 40 s
parseJ _ = error "empty"

parseStr :: String -> (String, String)
parseStr ('"':xs) = ("", xs)
parseStr (c:xs) = let (a,b) = parseStr xs in (c:a,b)
parseStr _ = error "str"

skipSpace :: String -> String
skipSpace = dropWhile (==' ')

parseArr :: String -> ([J], String)
parseArr s =
  case skipSpace s of
    ']':r -> ([], r)
    s' ->
      let (v,r1) = parseJ s'
      in case skipSpace r1 of
           ',':r2 -> let (vs,r3)=parseArr r2 in (v:vs,r3)
           ']':r2 -> ([v], r2)
           r2 -> error $ "arr: " ++ take 40 r2

parseObj :: String -> ([(String,J)], String)
parseObj s =
  case skipSpace s of
    '}':r -> ([], r)
    s' ->
      let (JStr k, r1) = parseJ s'
          ':':r2 = skipSpace r1
          (v,r3) = parseJ (skipSpace r2)
      in case skipSpace r3 of
           ',':r4 -> let (ps,r5)=parseObj r4 in ((k,v):ps,r5)
           '}':r4 -> ([(k,v)], r4)
           r4 -> error $ "obj: " ++ take 40 r4

sumNonRed :: J -> Int
sumNonRed (JNum n) = n
sumNonRed (JStr _) = 0
sumNonRed (JArr xs) = sum $ map sumNonRed xs
sumNonRed (JObj ps)
  | any (\(_,v) -> case v of JStr "red" -> True; _ -> False) ps = 0
  | otherwise = sum $ map (sumNonRed . snd) ps

part1 :: Int
part1 = sumNums input

part2 :: Int
part2 = sumNonRed . fst $ parseJ input
