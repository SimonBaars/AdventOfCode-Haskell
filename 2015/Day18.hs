import Data.Array.Unboxed
import Data.List (foldl')
import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

type Grid = UArray (Int,Int) Bool

raw :: [String]
raw = unsafePerformIO $ readInputLines 2015 18

n :: Int
n = length raw - 1

initial :: Grid
initial = array ((0,0),(n,n)) [((r,c), raw!!r!!c == '#') | r<-[0..n], c<-[0..n]]

neighbors :: (Int,Int) -> [(Int,Int)]
neighbors (r,c) = [(r+dr,c+dc) | dr<-[-1..1], dc<-[-1..1], (dr,dc)/=(0,0)
                  , let r'=r+dr; c'=c+dc, r'>=0, c'>=0, r'<=n, c'<=n]

countOn :: Grid -> (Int,Int) -> Int
countOn g p = length $ filter (g!) $ neighbors p

step :: (Grid -> Grid) -> Grid -> Grid
step cornerFix g = cornerFix $ array (bounds g)
  [ (p, let on = g!p; k = countOn g p in if on then k==2 || k==3 else k==3)
  | p <- range (bounds g) ]

cornersOn :: Grid -> Grid
cornersOn g = g // [((0,0),True),((0,n),True),((n,0),True),((n,n),True)]

run :: Int -> (Grid -> Grid) -> Grid -> Int
run k fix g0 = length $ filter id $ elems $ iterate (step fix) g0 !! k

part1 :: Int
part1 = run 100 id initial

part2 :: Int
part2 = run 100 cornersOn (cornersOn initial)
