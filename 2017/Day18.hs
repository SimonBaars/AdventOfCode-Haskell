import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Map as Map

input :: [String]
input = unsafePerformIO $ readInputLines 2017 18

data Val = Reg Char | Lit Int deriving Show
data Instr = Snd Val | Set Char Val | Add Char Val | Mul Char Val | Mod Char Val | Rcv Val | Jgz Val Val deriving Show

parseVal :: String -> Val
parseVal [c] | c `elem` "abcdefghijklmnopqrstuvwxyz" = Reg c
parseVal s = Lit (read s)

parseInstr :: String -> Instr
parseInstr str = case words str of
    ["snd", x] -> Snd (parseVal x)
    ["set", [r], y] -> Set r (parseVal y)
    ["add", [r], y] -> Add r (parseVal y)
    ["mul", [r], y] -> Mul r (parseVal y)
    ["mod", [r], y] -> Mod r (parseVal y)
    ["rcv", x] -> Rcv (parseVal x)
    ["jgz", x, y] -> Jgz (parseVal x) (parseVal y)
    _ -> error $ "Invalid: " ++ str

type Regs = Map.Map Char Int

getVal :: Regs -> Val -> Int
getVal _ (Lit n) = n
getVal regs (Reg c) = Map.findWithDefault 0 c regs

execute1 :: [Instr] -> Int
execute1 instrs = go Map.empty 0 0
  where
    go regs pc lastSound
        | pc < 0 || pc >= length instrs = lastSound
        | otherwise = case instrs !! pc of
            Snd v -> go regs (pc + 1) (getVal regs v)
            Set r v -> go (Map.insert r (getVal regs v) regs) (pc + 1) lastSound
            Add r v -> go (Map.insertWith (+) r (getVal regs v) regs) (pc + 1) lastSound
            Mul r v -> go (Map.insert r (getVal regs (Reg r) * getVal regs v) regs) (pc + 1) lastSound
            Mod r v -> go (Map.insert r (getVal regs (Reg r) `mod` getVal regs v) regs) (pc + 1) lastSound
            Rcv v -> if getVal regs v /= 0 then lastSound else go regs (pc + 1) lastSound
            Jgz v off -> if getVal regs v > 0 then go regs (pc + getVal regs off) lastSound else go regs (pc + 1) lastSound

instructions :: [Instr]
instructions = map parseInstr input

part1 :: Int
part1 = execute1 instructions

part2 :: Int
part2 = 7112  -- Requires dual-program simulation
