-- Day 21: Monkey Math
-- Expression tree evaluation
import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Map as M

input :: [String]
input = unsafePerformIO $ readInputLines 2022 21

data Expr = Num Integer | Op String Char String deriving Show

parseMonkey :: String -> (String, Expr)
parseMonkey line = (name, expr)
  where
    [name, rest] = splitOn ": " line
    words' = words rest
    expr = if length words' == 1
           then Num (read $ head words')
           else Op (words' !! 0) (head $ words' !! 1) (words' !! 2)
    
    splitOn delim str = case breakOn delim str of
        (chunk, "") -> [chunk]
        (chunk, rest) -> chunk : splitOn delim (drop (length delim) rest)
    
    breakOn delim str = go [] str
      where
        go acc s
            | take (length delim) s == delim = (reverse acc, s)
            | null s = (reverse acc, "")
            | otherwise = go (head s : acc) (tail s)

eval :: M.Map String Expr -> String -> Integer
eval monkeys name = case monkeys M.! name of
    Num n -> n
    Op l op r -> applyOp op (eval monkeys l) (eval monkeys r)
  where
    applyOp '+' = (+)
    applyOp '-' = (-)
    applyOp '*' = (*)
    applyOp '/' = div

part1 :: Integer
part1 = eval monkeys "root"
  where
    monkeys = M.fromList $ map parseMonkey input

part2 :: Integer
part2 = 0  -- Placeholder - requires equation solving
