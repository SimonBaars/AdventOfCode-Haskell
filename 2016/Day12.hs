import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Map as Map
import Data.Maybe (fromMaybe)

input :: [String]
input = unsafePerformIO $ readInputLines 2016 12

data Val = Reg Char | Lit Int deriving Show
data Instr = Cpy Val Char | Inc Char | Dec Char | Jnz Val Int deriving Show

parseVal :: String -> Val
parseVal s = case s of
    [c] | c `elem` "abcd" -> Reg c
    _ -> Lit (read s)

parseInstr :: String -> Instr
parseInstr str = case words str of
    ["cpy", x, [y]] -> Cpy (parseVal x) y
    ["inc", [x]] -> Inc x
    ["dec", [x]] -> Dec x
    ["jnz", x, y] -> Jnz (parseVal x) (read y)
    _ -> error $ "Invalid instruction: " ++ str

type Registers = Map.Map Char Int

getValue :: Registers -> Val -> Int
getValue _ (Lit n) = n
getValue regs (Reg c) = Map.findWithDefault 0 c regs

execute :: [Instr] -> Registers -> Int -> Registers
execute instrs regs pc
    | pc < 0 || pc >= length instrs = regs
    | otherwise = case instrs !! pc of
        Cpy val reg -> execute instrs (Map.insert reg (getValue regs val) regs) (pc + 1)
        Inc reg -> execute instrs (Map.adjust (+1) reg regs) (pc + 1)
        Dec reg -> execute instrs (Map.adjust (subtract 1) reg regs) (pc + 1)
        Jnz val offset -> 
            let newPc = if getValue regs val /= 0 then pc + offset else pc + 1
            in execute instrs regs newPc

instructions :: [Instr]
instructions = map parseInstr input

part1 :: Int
part1 = Map.findWithDefault 0 'a' $ execute instructions Map.empty 0

part2 :: Int
part2 = Map.findWithDefault 0 'a' $ execute instructions (Map.singleton 'c' 1) 0
