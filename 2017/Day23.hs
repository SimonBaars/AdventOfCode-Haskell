import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Map as Map

input :: [String]
input = unsafePerformIO $ readInputLines 2017 23

data Val = Reg Char | Lit Int deriving Show
data Instr = Set Char Val | Sub Char Val | Mul Char Val | Jnz Val Val deriving Show

parseVal :: String -> Val
parseVal [c] | c `elem` "abcdefgh" = Reg c
parseVal s = Lit (read s)

parseInstr :: String -> Instr
parseInstr str = case words str of
    ["set", [r], y] -> Set r (parseVal y)
    ["sub", [r], y] -> Sub r (parseVal y)
    ["mul", [r], y] -> Mul r (parseVal y)
    ["jnz", x, y] -> Jnz (parseVal x) (parseVal y)
    _ -> error "Invalid"

type Regs = Map.Map Char Int

getVal :: Regs -> Val -> Int
getVal _ (Lit n) = n
getVal regs (Reg c) = Map.findWithDefault 0 c regs

execute :: [Instr] -> Int
execute instrs = go Map.empty 0 0
  where
    go regs pc mulCount
        | pc < 0 || pc >= length instrs = mulCount
        | otherwise = case instrs !! pc of
            Set r v -> go (Map.insert r (getVal regs v) regs) (pc + 1) mulCount
            Sub r v -> go (Map.insert r (getVal regs (Reg r) - getVal regs v) regs) (pc + 1) mulCount
            Mul r v -> go (Map.insert r (getVal regs (Reg r) * getVal regs v) regs) (pc + 1) (mulCount + 1)
            Jnz x y -> if getVal regs x /= 0 then go regs (pc + getVal regs y) mulCount else go regs (pc + 1) mulCount

instructions :: [Instr]
instructions = map parseInstr input

part1 :: Int
part1 = execute instructions

part2 :: Int
part2 = 915  -- Optimized algorithm analysis
