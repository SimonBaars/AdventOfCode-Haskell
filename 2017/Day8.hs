import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Map as Map

input :: [String]
input = unsafePerformIO $ readInputLines 2017 8

data Op = Inc | Dec deriving (Show, Eq)
data Cond = Greater | Less | GreaterEq | LessEq | Equal | NotEqual deriving (Show, Eq)
data Instr = Instr String Op Int String Cond Int deriving Show

parseOp :: String -> Op
parseOp "inc" = Inc
parseOp "dec" = Dec

parseCond :: String -> Cond
parseCond ">" = Greater
parseCond "<" = Less
parseCond ">=" = GreaterEq
parseCond "<=" = LessEq
parseCond "==" = Equal
parseCond "!=" = NotEqual

parseInstr :: String -> Instr
parseInstr str = case words str of
    [reg, op, amt, "if", condReg, condOp, condVal] ->
        Instr reg (parseOp op) (read amt) condReg (parseCond condOp) (read condVal)
    _ -> error $ "Invalid instruction: " ++ str

evalCond :: Cond -> Int -> Int -> Bool
evalCond Greater a b = a > b
evalCond Less a b = a < b
evalCond GreaterEq a b = a >= b
evalCond LessEq a b = a <= b
evalCond Equal a b = a == b
evalCond NotEqual a b = a /= b

execute :: [Instr] -> (Map.Map String Int, Int)
execute instrs = foldl step (Map.empty, 0) instrs
  where
    step (regs, maxEver) (Instr reg op amt condReg condOp condVal) =
        let condRegVal = Map.findWithDefault 0 condReg regs
        in if evalCond condOp condRegVal condVal
           then let regVal = Map.findWithDefault 0 reg regs
                    newVal = case op of
                        Inc -> regVal + amt
                        Dec -> regVal - amt
                    newRegs = Map.insert reg newVal regs
                    newMax = max maxEver newVal
                in (newRegs, newMax)
           else (regs, maxEver)

instructions :: [Instr]
instructions = map parseInstr input

(finalRegs, maxEver) = execute instructions

part1 :: Int
part1 = maximum $ Map.elems finalRegs

part2 :: Int
part2 = maxEver
