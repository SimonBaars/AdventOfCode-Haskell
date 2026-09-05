import Data.Bits
import Data.Char (isDigit)
import qualified Data.Map.Strict as M
import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

type Wire = String
type Val = Int

input :: [String]
input = unsafePerformIO $ readInputLines 2015 7

data Expr = Lit Val | Var Wire | Not Expr | Bin String Expr Expr deriving (Show)

splitArrow :: String -> (String, String)
splitArrow s =
  case break (=='-') s of
    (lhs, '-':'>':rhs) -> (reverse . dropWhile (==' ') . reverse $ lhs, dropWhile (==' ') rhs)
    _ -> error s

parseLine :: String -> (Wire, Expr)
parseLine line =
  let (exprStr, wire) = splitArrow line
  in (wire, parseExpr (words exprStr))

parseExpr :: [String] -> Expr
parseExpr [a] = atom a
parseExpr ["NOT", a] = Not (atom a)
parseExpr [a, op, b] = Bin op (atom a) (atom b)
parseExpr ws = error $ show ws

atom :: String -> Expr
atom s | all isDigit s = Lit (read s)
       | otherwise = Var s

eval :: M.Map Wire Expr -> M.Map Wire Val -> Wire -> (Val, M.Map Wire Val)
eval rules memo w
  | Just v <- M.lookup w memo = (v, memo)
  | otherwise =
      let (v, memo') = evalExpr rules memo (rules M.! w)
      in (v, M.insert w v memo')

evalExpr :: M.Map Wire Expr -> M.Map Wire Val -> Expr -> (Val, M.Map Wire Val)
evalExpr _ memo (Lit n) = (n .&. 0xFFFF, memo)
evalExpr rules memo (Var w) = eval rules memo w
evalExpr rules memo (Not e) =
  let (v, m) = evalExpr rules memo e in ((complement v) .&. 0xFFFF, m)
evalExpr rules memo (Bin op a b) =
  let (va, m1) = evalExpr rules memo a
      (vb, m2) = evalExpr rules m1 b
      r = case op of
        "AND" -> va .&. vb
        "OR" -> va .|. vb
        "LSHIFT" -> shiftL va vb
        "RSHIFT" -> shiftR va vb
        _ -> error op
  in (r .&. 0xFFFF, m2)

solve :: M.Map Wire Expr -> Val
solve rules = fst $ eval rules M.empty "a"

rules0 :: M.Map Wire Expr
rules0 = M.fromList $ map parseLine input

part1 :: Int
part1 = solve rules0

part2 :: Int
part2 = solve (M.insert "b" (Lit part1) rules0)
