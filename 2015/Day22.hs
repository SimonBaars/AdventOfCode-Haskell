import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Set as Set

input :: (Int, Int)
input = unsafePerformIO $ parseInput <$> readInputLines 2015 22

parseInput :: [String] -> (Int, Int)
parseInput ls = (read $ last $ words $ head ls, read $ last $ words $ ls !! 1)

data Spell = MagicMissile | Drain | Shield | Poison | Recharge deriving (Eq, Ord, Show)

data State = State
    { php :: Int, mana :: Int, bhp :: Int, bdmg :: Int
    , shield :: Int, poison :: Int, recharge :: Int
    } deriving (Eq, Ord, Show)

cost :: Spell -> Int
cost MagicMissile = 53
cost Drain = 73
cost Shield = 113
cost Poison = 173
cost Recharge = 229

applyEffects :: State -> State
applyEffects s = s
    { bhp = bhp s - if poison s > 0 then 3 else 0
    , mana = mana s + if recharge s > 0 then 101 else 0
    , shield = max 0 (shield s - 1)
    , poison = max 0 (poison s - 1)
    , recharge = max 0 (recharge s - 1)
    }

cast :: State -> Spell -> State
cast s MagicMissile = s { bhp = bhp s - 4, mana = mana s - 53 }
cast s Drain = s { bhp = bhp s - 2, php = php s + 2, mana = mana s - 73 }
cast s Shield = s { shield = 6, mana = mana s - 113 }
cast s Poison = s { poison = 6, mana = mana s - 173 }
cast s Recharge = s { recharge = 5, mana = mana s - 229 }

canCast :: State -> Spell -> Bool
canCast s sp = mana s >= cost sp && case sp of
    Shield -> shield s == 0
    Poison -> poison s == 0
    Recharge -> recharge s == 0
    _ -> True

bossAttack :: State -> State
bossAttack s = s { php = php s - max 1 (bdmg s - if shield s > 0 then 7 else 0) }

spells :: [Spell]
spells = [MagicMissile, Drain, Shield, Poison, Recharge]

minMana :: Bool -> State -> Int
minMana hard init = go [(init, 0)] Set.empty maxBound
  where
    go [] _ best = best
    go ((s, used):queue) seen best
        | used >= best = go queue seen best
        | key `Set.member` seen = go queue seen best
        | otherwise = go (newStates ++ queue) (Set.insert key seen) newBest
      where
        key = (php s, mana s, bhp s, shield s, poison s, recharge s)
        
        -- Player turn
        s1 = if hard then s { php = php s - 1 } else s
        s2 = applyEffects s1
        
        playerDied = php s1 <= 0
        bossDeadAfterEffects = bhp s2 <= 0
        
        -- Check for immediate wins and calculate next best
        wins1 = [used | bossDeadAfterEffects && not playerDied]
        
        validMoves = if playerDied || bossDeadAfterEffects
                     then []
                     else [(sp, cost sp) | sp <- spells, canCast s2 sp]
        
        wins2 = [used + c
                | (sp, c) <- validMoves
                , let s3 = cast s2 sp
                , bhp s3 <= 0
                ]
        
        wins3 = [used + c
                | (sp, c) <- validMoves
                , let s3 = cast s2 sp
                , bhp s3 > 0
                , let s4 = applyEffects s3
                , bhp s4 <= 0
                ]
        
        results = [(final, used + c)
                  | (sp, c) <- validMoves
                  , let s3 = cast s2 sp
                  , bhp s3 > 0
                  , let s4 = applyEffects s3
                  , bhp s4 > 0
                  , let s5 = bossAttack s4
                  , let final = s5
                  , php final > 0
                  ]
        
        allWins = wins1 ++ wins2 ++ wins3
        newBest = if null allWins then best else min best (minimum allWins)
        newStates = results

part1 :: Int
part1 = minMana False (State 50 500 (fst input) (snd input) 0 0 0)

part2 :: Int
part2 = minMana True (State 50 500 (fst input) (snd input) 0 0 0)
