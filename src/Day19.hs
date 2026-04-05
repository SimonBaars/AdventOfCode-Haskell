module Day19 (part1, part2) where

import Control.Monad.State
import qualified Data.Map as Map
data Blueprint = BP
  { bpId :: Int,
    oreOre :: Int,
    clayOre :: Int,
    obsOre :: Int,
    obsClay :: Int,
    geoOre :: Int,
    geoObs :: Int
  }

parseBlueprint :: String -> Blueprint
parseBlueprint s =
  let ws = words $ filter (`notElem` ":") s
      nums = map read $ filter (all (`elem` ('-' : ['0' .. '9']))) ws
   in case nums of
        [i, a, b, c, d, e, f] -> BP i a b c d e f
        _ -> error "Day19: blueprint"

maxOreRobots :: Blueprint -> Int
maxOreRobots bp = maximum [oreOre bp, clayOre bp, obsOre bp, geoOre bp]

type Memo = Map.Map (Int, Int, Int, Int, Int, Int, Int, Int) Int

runBP :: Int -> Blueprint -> Int
runBP maxT bp = evalState (go maxT 0 0 0 1 0 0 0) Map.empty
  where
    mo = maxOreRobots bp
    maxClayR = obsClay bp
    maxObsR = geoObs bp
    go :: Int -> Int -> Int -> Int -> Int -> Int -> Int -> Int -> State Memo Int
    go !t !o !c !ob !r1 !r2 !r3 !r4
      | t == 0 = pure 0
      | otherwise = do
          memo <- get
          let key = (t, o, c, ob, r1, r2, r3, r4)
          case Map.lookup key memo of
            Just v -> pure v
            Nothing -> do
              let o1 = o + r1
                  c1 = c + r2
                  ob1 = ob + r3
                  this = r4
              w <- go (t - 1) o1 c1 ob1 r1 r2 r3 r4
              g <-
                if o1 >= geoOre bp && ob1 >= geoObs bp
                  then go (t - 1) (o1 - geoOre bp) c1 (ob1 - geoObs bp) r1 r2 r3 (r4 + 1)
                  else pure 0
              obR <-
                if r3 < maxObsR && o1 >= obsOre bp && c1 >= obsClay bp
                  then go (t - 1) (o1 - obsOre bp) (c1 - obsClay bp) ob1 r1 r2 (r3 + 1) r4
                  else pure 0
              cl <-
                if r2 < maxClayR && o1 >= clayOre bp
                  then go (t - 1) (o1 - clayOre bp) c1 ob1 r1 (r2 + 1) r3 r4
                  else pure 0
              orR <-
                if r1 < mo && o1 >= oreOre bp
                  then go (t - 1) (o1 - oreOre bp) c1 ob1 (r1 + 1) r2 r3 r4
                  else pure 0
              let ans = this + maximum [w, g, obR, cl, orR]
              modify $ Map.insert key ans
              pure ans

part1 :: String -> Int
part1 s =
  let bps = map parseBlueprint $ lines s
   in sum $ map (\bp -> bpId bp * runBP 24 bp) bps

part2 :: String -> Int
part2 s =
  let bps = take 3 $ map parseBlueprint $ lines s
   in product $ map (runBP 32) bps
