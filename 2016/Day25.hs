import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Map as Map
import Data.Maybe (fromMaybe)

input :: [String]
input = unsafePerformIO $ readInputLines 2016 25

data Val = Reg Char | Lit Int deriving Show
data Instr = Cpy Val Char | Inc Char | Dec Char | Jnz Val Val | Out Val deriving Show

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
    ["out", x] -> Out (parseVal x)
    _ -> error $ "Invalid instruction: " ++ str

type Registers = Map.Map Char Int

getValue :: Registers -> Val -> Int
getValue _ (Lit n) = n
getValue regs (Reg c) = Map.findWithDefault 0 c regs

execute :: [Instr] -> Registers -> Int -> [Int] -> [Int]
execute instrs regs pc output
    | length output > 20 = output
    | pc < 0 || pc >= length instrs = output
    | otherwise = case instrs !! pc of
        Cpy val reg -> execute instrs (Map.insert reg (getValue regs val) regs) (pc + 1) output
        Inc reg -> execute instrs (Map.adjust (+1) reg regs) (pc + 1) output
        Dec reg -> execute instrs (Map.adjust (subtract 1) reg regs) (pc + 1) output
        Jnz val offset -> 
            let newPc = if getValue regs val /= 0 then pc + getValue regs offset else pc + 1
            in execute instrs regs newPc output
        Out val -> execute instrs regs (pc + 1) (output ++ [getValue regs val])

isClockSignal :: [Int] -> Bool
isClockSignal output = take 20 output == take 20 (cycle [0, 1])

findClockInput :: [Instr] -> Int
findClockInput instrs = head [a | a <- [1..], isClockSignal $ execute instrs (Map.singleton 'a' a) 0 []]

instructions :: [Instr]
instructions = map parseInstr input

part1 :: Int
part1 = findClockInput instructions

part2 :: String
part2 = "Merry Christmas!"
