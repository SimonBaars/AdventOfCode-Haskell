module Day21 (part1, part2) where

import Control.Monad.State
import qualified Data.Map as Map

parse :: String -> (Int, Int)
parse s =
  case lines s of
    [a, b] -> (read $ last $ words a, read $ last $ words b)
    _ -> error "Day21: parse"

move :: Int -> Int -> Int
move p steps = ((p - 1 + steps) `mod` 10) + 1

roll3 :: Int -> (Int, Int)
roll3 d =
  let r1 = ((d - 1) `mod` 100) + 1
      r2 = (d `mod` 100) + 1
      r3 = ((d + 1) `mod` 100) + 1
   in (r1 + r2 + r3, d + 3)

part1 :: String -> Int
part1 s =
  let (p1, p2) = parse s
      loop !p1' !p2' !s1 !s2 !d !rolls
        | s1 >= 1000 = s2 * rolls
        | s2 >= 1000 = s1 * rolls
        | otherwise =
            let (mv, d') = roll3 d
                np1 = move p1' mv
                ns1 = s1 + np1
                rolls' = rolls + 3
             in if ns1 >= 1000
                  then s2 * rolls'
                  else
                    let (mv2, d'') = roll3 d'
                        np2 = move p2' mv2
                        ns2 = s2 + np2
                        rolls'' = rolls' + 3
                     in if ns2 >= 1000
                          then s1 * rolls''
                          else loop np1 np2 ns1 ns2 d'' rolls''
   in loop p1 p2 0 0 1 0

dirac :: [(Int, Integer)]
dirac =
  Map.toList $
    Map.fromListWith (+) $
      [ (a + b + c, 1)
        | a <- [1 .. 3],
          b <- [1 .. 3],
          c <- [1 .. 3]
      ]

type Key = (Int, Int, Int, Int, Bool)

type MemoM = State (Map.Map Key (Integer, Integer))

wins :: Key -> MemoM (Integer, Integer)
wins k@(p1, p2, s1, s2, p1turn)
  | s1 >= 21 = pure (1, 0)
  | s2 >= 21 = pure (0, 1)
  | otherwise = do
      memo <- get
      case Map.lookup k memo of
        Just v -> pure v
        Nothing -> do
          let branch (mv, cnt) =
                if p1turn
                  then
                    let np = move p1 mv
                        ns = s1 + np
                     in if ns >= 21
                          then pure (cnt, 0)
                          else
                            wins (np, p2, ns, s2, False) >>= \(wp1, wp2) ->
                              pure (cnt * wp1, cnt * wp2)
                  else
                    let np = move p2 mv
                        ns = s2 + np
                     in if ns >= 21
                          then pure (0, cnt)
                          else
                            wins (p1, np, s1, ns, True) >>= \(wp1, wp2) ->
                              pure (cnt * wp1, cnt * wp2)
          pairs <- mapM branch dirac
          let (wa, wb) = foldr (\(a, b) (x, y) -> (a + x, b + y)) (0, 0) pairs
          modify $ Map.insert k (wa, wb)
          pure (wa, wb)

part2 :: String -> Integer
part2 s =
  let (p1, p2) = parse s
      (a, b) = evalState (wins (p1, p2, 0, 0, True)) Map.empty
   in max a b
