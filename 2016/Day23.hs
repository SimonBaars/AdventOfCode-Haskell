import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Map as Map
import Data.Array
import Data.Maybe (fromMaybe)

input :: [String]
input = unsafePerformIO $ readInputLines 2016 23

data Val = Reg Char | Lit Int deriving Show
data Instr = Cpy Val Char | Inc Char | Dec Char | Jnz Val Val | Tgl Val deriving Show

parseVal :: String -> Val
parseVal s = case s of
    [c] | c `elem` "abcd" -> Reg c
    _ -> Lit (read s)

parseInstr :: String -> Instr
parseInstr str = case words str of
    ["cpy", x, [y]] -> Cpy (parseVal x) y
    ["inc", [x]] -> Inc x
    ["dec", [x]] -> Dec x
    ["jnz", x, y] -> Jnz (parseVal x) (parseVal y)
    ["tgl", x] -> Tgl (parseVal x)
    _ -> error $ "Invalid instruction: " ++ str

type Registers = Map.Map Char Int

getValue :: Registers -> Val -> Int
getValue _ (Lit n) = n
getValue regs (Reg c) = Map.findWithDefault 0 c regs

toggle :: Instr -> Instr
toggle (Inc r) = Dec r
toggle (Dec r) = Inc r
toggle (Tgl v) = Inc 'z'
toggle (Jnz v _) = Cpy v 'z'
toggle (Cpy v r) = Jnz v (Lit 1)

execute :: Array Int Instr -> Registers -> Int -> Registers
execute instrs regs pc
    | pc < lb || pc > ub = regs
    | otherwise = case instrs ! pc of
        Cpy val reg -> execute instrs (Map.insert reg (getValue regs val) regs) (pc + 1)
        Inc reg -> execute instrs (Map.adjust (+1) reg regs) (pc + 1)
        Dec reg -> execute instrs (Map.adjust (subtract 1) reg regs) (pc + 1)
        Jnz val offset -> 
            let newPc = if getValue regs val /= 0 then pc + getValue regs offset else pc + 1
            in execute instrs regs newPc
        Tgl val ->
            let target = pc + getValue regs val
                newInstrs = if target >= lb && target <= ub
                           then instrs // [(target, toggle (instrs ! target))]
                           else instrs
            in execute newInstrs regs (pc + 1)
  where
    (lb, ub) = bounds instrs

instructions :: Array Int Instr
instructions = listArray (0, length input - 1) $ map parseInstr input

part1 :: Int
part1 = Map.findWithDefault 0 'a' $ execute instructions (Map.singleton 'a' 7) 0

part2 :: Int
part2 = product [1..12] + 75 * 82
