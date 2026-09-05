import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.Array
import Data.List (sort)
import qualified Data.Set as Set

type Point = (Int, Int)
type HeightMap = Array Point Int

input :: HeightMap
input = unsafePerformIO $ parseInput <$> readInputLines 2021 9

parseInput :: [String] -> HeightMap
parseInput ls = listArray ((0, 0), (h-1, w-1)) [read [c] | row <- ls, c <- row]
  where
    h = length ls
    w = length (head ls)

neighbors :: HeightMap -> Point -> [Point]
neighbors hm (x, y) = filter (inRange (bounds hm)) [(x-1, y), (x+1, y), (x, y-1), (x, y+1)]

isLowPoint :: HeightMap -> Point -> Bool
isLowPoint hm p = all (\n -> hm ! p < hm ! n) (neighbors hm p)

lowPoints :: HeightMap -> [Point]
lowPoints hm = [p | p <- indices hm, isLowPoint hm p]

part1 :: Int
part1 = sum [1 + input ! p | p <- lowPoints input]

basinSize :: HeightMap -> Point -> Int
basinSize hm start = Set.size $ go (Set.singleton start) [start]
  where
    go visited [] = visited
    go visited (p:ps) = 
        let ns = [n | n <- neighbors hm p, hm ! n /= 9, n `Set.notMember` visited]
            visited' = foldr Set.insert visited ns
        in go visited' (ns ++ ps)

part2 :: Int
part2 = product $ take 3 $ reverse $ sort $ map (basinSize input) $ lowPoints input
