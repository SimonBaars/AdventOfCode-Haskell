import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Map as Map
import Data.List (isPrefixOf)

input :: [String]
input = unsafePerformIO $ readInputLines 2016 10

data Target = Bot Int | Output Int deriving (Show, Eq, Ord)
data Instruction = Value Int Int | Give Int Target Target deriving Show

parseInstruction :: String -> Instruction
parseInstruction str
    | "value" `isPrefixOf` str = 
        let ws = words str
        in Value (read $ ws !! 1) (read $ ws !! 5)
    | otherwise = 
        let ws = words str
            bot = read $ ws !! 1
            lowType = ws !! 5
            lowNum = read $ ws !! 6
            highType = ws !! 10
            highNum = read $ ws !! 11
            lowTarget = if lowType == "bot" then Bot lowNum else Output lowNum
            highTarget = if highType == "bot" then Bot highNum else Output highNum
        in Give bot lowTarget highTarget

type BotState = Map.Map Int [Int]
type OutputState = Map.Map Int Int

simulate :: [Instruction] -> (Maybe Int, Int)
simulate instructions = go (Map.empty, Map.empty) Nothing values
  where
    values = [(v, b) | Value v b <- instructions]
    gives = Map.fromList [(b, (low, high)) | Give b low high <- instructions]
    
    go (bots, outputs) found [] = 
        let result2 = product [outputs Map.! i | i <- [0,1,2], Map.member i outputs]
        in (found, result2)
    
    go (bots, outputs) found ((val, bot):vals) =
        let newBots = Map.insertWith (++) bot [val] bots
            (bots', outputs', found') = processReady newBots outputs gives found
        in go (bots', outputs') found' vals
    
    processReady bots outputs gives found =
        case [(bot, chips) | (bot, chips) <- Map.toList bots, length chips == 2] of
            [] -> (bots, outputs, found)
            ((bot, chips):_) ->
                let low = minimum chips
                    high = maximum chips
                    newFound = if low == 17 && high == 61 
                               then Just bot 
                               else found
                    (lowTarget, highTarget) = gives Map.! bot
                    bots1 = Map.delete bot bots
                    (bots2, outputs2) = case (lowTarget, highTarget) of
                        (Bot b1, Bot b2) -> (Map.insertWith (++) b1 [low] $ Map.insertWith (++) b2 [high] bots1, outputs)
                        (Bot b1, Output o2) -> (Map.insertWith (++) b1 [low] bots1, Map.insert o2 high outputs)
                        (Output o1, Bot b2) -> (Map.insertWith (++) b2 [high] bots1, Map.insert o1 low outputs)
                        (Output o1, Output o2) -> (bots1, Map.insert o1 low $ Map.insert o2 high outputs)
                in processReady bots2 outputs2 gives newFound

instructions :: [Instruction]
instructions = map parseInstruction input

result :: (Maybe Int, Int)
result = simulate instructions

part1 :: Int
part1 = case fst result of
    Just x -> x
    Nothing -> error "Bot not found"

part2 :: Int
part2 = snd result
