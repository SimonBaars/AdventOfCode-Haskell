import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Map as Map
import Data.Maybe (fromMaybe)

input :: [String]
input = unsafePerformIO $ readInputLines 2017 18

data Val = Reg Char | Lit Int deriving Show
data Instr = Snd Val | Set Char Val | Add Char Val | Mul Char Val | Mod Char Val | Rcv Char | Jgz Val Val deriving Show

parseVal :: String -> Val
parseVal [c] | c `elem` ['a'..'z'] = Reg c
parseVal s = Lit (read s)

parseInstr :: String -> Instr
parseInstr str = case words str of
    ["snd", x] -> Snd (parseVal x)
    ["set", [r], y] -> Set r (parseVal y)
    ["add", [r], y] -> Add r (parseVal y)
    ["mul", [r], y] -> Mul r (parseVal y)
    ["mod", [r], y] -> Mod r (parseVal y)
    ["rcv", [r]] -> Rcv r
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
            Rcv r -> if Map.findWithDefault 0 r regs /= 0 then lastSound else go regs (pc + 1) lastSound
            Jgz v off -> if getVal regs v > 0 then go regs (pc + getVal regs off) lastSound else go regs (pc + 1) lastSound

-- Dual program for part 2
data Prog = Prog { regs :: Regs, pc :: Int, queue :: [Int], sent :: Int, waiting :: Bool }

stepProg :: [Instr] -> Prog -> (Prog, Maybe Int)  -- Maybe Int = value sent
stepProg instrs p
  | pc p < 0 || pc p >= length instrs = (p { waiting = True }, Nothing)
  | otherwise = case instrs !! pc p of
      Snd v ->
        let val = getVal (regs p) v
        in (p { pc = pc p + 1, sent = sent p + 1, waiting = False }, Just val)
      Set r v ->
        (p { regs = Map.insert r (getVal (regs p) v) (regs p), pc = pc p + 1, waiting = False }, Nothing)
      Add r v ->
        (p { regs = Map.insertWith (+) r (getVal (regs p) v) (regs p), pc = pc p + 1, waiting = False }, Nothing)
      Mul r v ->
        (p { regs = Map.insert r (getVal (regs p) (Reg r) * getVal (regs p) v) (regs p), pc = pc p + 1, waiting = False }, Nothing)
      Mod r v ->
        (p { regs = Map.insert r (getVal (regs p) (Reg r) `mod` getVal (regs p) v) (regs p), pc = pc p + 1, waiting = False }, Nothing)
      Rcv r ->
        case queue p of
          (x:xs) -> (p { regs = Map.insert r x (regs p), queue = xs, pc = pc p + 1, waiting = False }, Nothing)
          [] -> (p { waiting = True }, Nothing)
      Jgz v off ->
        let npc = if getVal (regs p) v > 0 then pc p + getVal (regs p) off else pc p + 1
        in (p { pc = npc, waiting = False }, Nothing)

execute2 :: [Instr] -> Int
execute2 instrs = go p0 p1
  where
    p0 = Prog Map.empty 0 [] 0 False
    p1 = Prog (Map.singleton 'p' 1) 0 [] 0 False
    go a b
      | waiting a && waiting b = sent b
      | otherwise =
          let (a', sa) = stepProg instrs a
              (b', sb) = stepProg instrs b
              a'' = case sb of
                      Just v -> a' { queue = queue a' ++ [v], waiting = False }
                      Nothing -> a'
              b'' = case sa of
                      Just v -> b' { queue = queue b' ++ [v], waiting = False }
                      Nothing -> b'
          in if waiting a'' && waiting b'' && null (queue a'') && null (queue b'')
               then sent b''
               else go a'' b''

instructions :: [Instr]
instructions = map parseInstr input

part1 :: Int
part1 = execute1 instructions

part2 :: Int
part2 = execute2 instructions
