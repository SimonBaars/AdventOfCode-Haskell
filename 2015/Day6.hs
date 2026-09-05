import Control.Monad (forM_, when)
import Control.Monad.ST
import Data.Array.ST
import Data.Array.Unboxed
import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Text.Regex (mkRegex, matchRegex)

input :: [String]
input = unsafePerformIO $ readInputLines 2015 6

parse :: String -> (String, (Int,Int), (Int,Int))
parse line =
  case matchRegex (mkRegex "(turn on|turn off|toggle) ([0-9]+),([0-9]+) through ([0-9]+),([0-9]+)") line of
    Just [op,x1,y1,x2,y2] -> (op, (read x1, read y1), (read x2, read y2))
    _ -> error line

run1 :: Int
run1 = runST $ do
  g <- newArray ((0,0),(999,999)) False :: ST s (STUArray s (Int,Int) Bool)
  forM_ (map parse input) $ \(op,(x1,y1),(x2,y2)) ->
    forM_ [x1..x2] $ \x -> forM_ [y1..y2] $ \y -> do
      v <- readArray g (x,y)
      let v' = case op of
            "turn on" -> True
            "turn off" -> False
            "toggle" -> not v
            _ -> v
      writeArray g (x,y) v'
  elems' <- getElems g
  return $ length $ filter id elems'

run2 :: Int
run2 = runST $ do
  g <- newArray ((0,0),(999,999)) 0 :: ST s (STUArray s (Int,Int) Int)
  forM_ (map parse input) $ \(op,(x1,y1),(x2,y2)) ->
    forM_ [x1..x2] $ \x -> forM_ [y1..y2] $ \y -> do
      v <- readArray g (x,y)
      let v' = case op of
            "turn on" -> v + 1
            "turn off" -> max 0 (v - 1)
            "toggle" -> v + 2
            _ -> v
      writeArray g (x,y) v'
  sum <$> getElems g

part1 :: Int
part1 = run1

part2 :: Int
part2 = run2
