import Data.Array.Unboxed
import Data.List (find)
import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)

target :: Int
target = read $ unsafePerformIO $ readInput 2015 20

-- sieve of presents
solve1 :: Int -> Int
solve1 tgt =
  let limit = tgt `div` 10
      arr = accumArray (+) 0 (1,limit) [(i, 10*e) | e<-[1..limit], i<-[e,e+e..limit]] :: UArray Int Int
  in maybe limit fst $ find ((>=tgt) . snd) $ assocs arr

solve2 :: Int -> Int
solve2 tgt =
  let limit = tgt `div` 11
      arr = accumArray (+) 0 (1,limit)
            [(i, 11*e) | e<-[1..limit], i<-take 50 [e,e+e..limit]] :: UArray Int Int
  in maybe limit fst $ find ((>=tgt) . snd) $ assocs arr

part1 :: Int
part1 = solve1 target

part2 :: Int
part2 = solve2 target
