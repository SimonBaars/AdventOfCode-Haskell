-- | Intcode computer implementation for Advent of Code 2019
module Intcode
    ( Program
    , parseProgram
    , runProgram
    , runWithInput
    , runUntilOutput
    , VM(..)
    , State(..)
    , initVM
    , step
    ) where

import qualified Data.Map as Map
import Data.List.Split (splitOn)

type Memory = Map.Map Int Int
type Program = [Int]

data State = Running | Halted | WaitingInput | OutputReady deriving (Eq, Show)

data VM = VM
    { memory :: Memory
    , pc :: Int
    , relBase :: Int
    , state :: State
    , input :: [Int]
    , output :: [Int]
    } deriving Show

parseProgram :: String -> Program
parseProgram = map read . splitOn "," . filter (/= '\n')

initVM :: Program -> [Int] -> VM
initVM prog inputs = VM
    { memory = Map.fromList (zip [0..] prog)
    , pc = 0
    , relBase = 0
    , state = Running
    , input = inputs
    , output = []
    }

getParam :: VM -> Int -> Int -> Int
getParam vm mode offset =
    let addr = pc vm + offset
        val = Map.findWithDefault 0 addr (memory vm)
    in case mode of
        0 -> Map.findWithDefault 0 val (memory vm)  -- position
        1 -> val                                      -- immediate
        2 -> Map.findWithDefault 0 (relBase vm + val) (memory vm)  -- relative

getAddr :: VM -> Int -> Int -> Int
getAddr vm mode offset =
    let addr = pc vm + offset
        val = Map.findWithDefault 0 addr (memory vm)
    in case mode of
        0 -> val
        2 -> relBase vm + val
        _ -> error "Invalid address mode"

step :: VM -> VM
step vm
    | state vm /= Running = vm
    | otherwise =
        let op = Map.findWithDefault 0 (pc vm) (memory vm)
            opcode = op `mod` 100
            mode1 = (op `div` 100) `mod` 10
            mode2 = (op `div` 1000) `mod` 10
            mode3 = (op `div` 10000) `mod` 10
        in case opcode of
            99 -> vm { state = Halted }
            1 -> let a = getParam vm mode1 1
                     b = getParam vm mode2 2
                     dest = getAddr vm mode3 3
                 in vm { memory = Map.insert dest (a + b) (memory vm)
                       , pc = pc vm + 4 }
            2 -> let a = getParam vm mode1 1
                     b = getParam vm mode2 2
                     dest = getAddr vm mode3 3
                 in vm { memory = Map.insert dest (a * b) (memory vm)
                       , pc = pc vm + 4 }
            3 -> case input vm of
                    [] -> vm { state = WaitingInput }
                    (i:is) -> let dest = getAddr vm mode1 1
                             in vm { memory = Map.insert dest i (memory vm)
                                   , pc = pc vm + 2
                                   , input = is }
            4 -> let val = getParam vm mode1 1
                 in vm { output = output vm ++ [val]
                       , pc = pc vm + 2
                       , state = OutputReady }
            5 -> let a = getParam vm mode1 1
                     b = getParam vm mode2 2
                 in vm { pc = if a /= 0 then b else pc vm + 3 }
            6 -> let a = getParam vm mode1 1
                     b = getParam vm mode2 2
                 in vm { pc = if a == 0 then b else pc vm + 3 }
            7 -> let a = getParam vm mode1 1
                     b = getParam vm mode2 2
                     dest = getAddr vm mode3 3
                 in vm { memory = Map.insert dest (if a < b then 1 else 0) (memory vm)
                       , pc = pc vm + 4 }
            8 -> let a = getParam vm mode1 1
                     b = getParam vm mode2 2
                     dest = getAddr vm mode3 3
                 in vm { memory = Map.insert dest (if a == b then 1 else 0) (memory vm)
                       , pc = pc vm + 4 }
            9 -> let a = getParam vm mode1 1
                 in vm { relBase = relBase vm + a
                       , pc = pc vm + 2 }
            _ -> error $ "Unknown opcode: " ++ show opcode

runProgram :: Program -> [Int] -> [Int]
runProgram prog inputs = output $ runUntilHalt $ initVM prog inputs

runUntilHalt :: VM -> VM
runUntilHalt vm
    | state vm == Halted = vm
    | otherwise = runUntilHalt (step vm)

runWithInput :: VM -> [Int] -> VM
runWithInput vm inputs = vm { input = input vm ++ inputs, state = Running }

runUntilOutput :: VM -> VM
runUntilOutput vm
    | state vm == Halted || state vm == OutputReady = vm
    | otherwise = runUntilOutput (step vm)
