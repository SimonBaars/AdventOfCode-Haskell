import Data.List (maximumBy, minimumBy)
import Data.Ord (comparing)
import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

-- Shop
weapons :: [(Int,Int,Int)] -- cost, damage, armor
weapons =
  [ (8,4,0),(10,5,0),(25,6,0),(40,7,0),(74,8,0) ]

armors :: [(Int,Int,Int)]
armors =
  [ (0,0,0) -- none
  , (13,0,1),(31,0,2),(53,0,3),(75,0,4),(102,0,5)
  ]

rings :: [(Int,Int,Int)]
rings =
  [ (0,0,0),(0,0,0) -- allow up to 2, with empties
  , (25,1,0),(50,2,0),(100,3,0),(20,0,1),(40,0,2),(80,0,3)
  ]

boss :: (Int,Int,Int) -- hp, damage, armor
boss =
  let ls = unsafePerformIO $ readInputLines 2015 21
      nums = map (read . last . words) ls :: [Int]
  in (nums!!0, nums!!1, nums!!2)

loadouts :: [(Int,Int,Int)]
loadouts =
  [ (cw+ca+cr1+cr2, dw+da+dr1+dr2, aw+aa+ar1+ar2)
  | (cw,dw,aw) <- weapons
  , (ca,da,aa) <- armors
  , (i,(cr1,dr1,ar1)) <- zip [0..] rings
  , (j,(cr2,dr2,ar2)) <- zip [0..] rings
  , i < j || (cr1,dr1,ar1)==(0,0,0) && (cr2,dr2,ar2)==(0,0,0) && i==j -- allow double none once
  ]

-- Fix ring selection properly: 0, 1, or 2 distinct rings
loadouts' :: [(Int,Int,Int)]
loadouts' =
  let realRings = drop 2 rings -- actual rings
      none = (0,0,0)
      ringChoices =
        [ [none,none] ]
        ++ [ [r,none] | r <- realRings ]
        ++ [ [r1,r2] | (i,r1) <- zip [0..] realRings, (j,r2) <- zip [0..] realRings, i < j ]
  in [ (cw+ca+cr1+cr2, dw+da+dr1+dr2, aw+aa+ar1+ar2)
     | (cw,dw,aw) <- weapons
     , (ca,da,aa) <- armors
     , [(cr1,dr1,ar1),(cr2,dr2,ar2)] <- ringChoices
     ]

playerWins :: (Int,Int,Int) -> Bool
playerWins (_, dmg, arm) =
  let (bhp, bdmg, barm) = boss
      pDmg = max 1 (dmg - barm)
      bDmg = max 1 (bdmg - arm)
      pTurns = (bhp + pDmg - 1) `div` pDmg
      bTurns = (100 + bDmg - 1) `div` bDmg
  in pTurns <= bTurns

part1 :: Int
part1 = minimum [ c | l@(c,_,_) <- loadouts', playerWins l ]

part2 :: Int
part2 = maximum [ c | l@(c,_,_) <- loadouts', not (playerWins l) ]
