import qualified Data.Set as Set
import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)

input :: String
input = unsafePerformIO $ readInput 2015 3

step :: (Int,Int) -> Char -> (Int,Int)
step (x,y) '^' = (x,y+1)
step (x,y) 'v' = (x,y-1)
step (x,y) '>' = (x+1,y)
step (x,y) '<' = (x-1,y)
step p _ = p

houses :: String -> Set.Set (Int,Int)
houses s = Set.fromList $ scanl step (0,0) s

part1 :: Int
part1 = Set.size $ houses input

part2 :: Int
part2 = Set.size $ Set.union (houses santa) (houses robot)
  where
    santa = [c | (i,c) <- zip [0..] input, even i]
    robot = [c | (i,c) <- zip [0..] input, odd i]
