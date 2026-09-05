import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.Array
import qualified Data.Set as Set

type Grid = Array (Int, Int) Int

input :: Grid
input = unsafePerformIO $ parseGrid <$> readInputLines 2021 11

parseGrid :: [String] -> Grid
parseGrid ls = listArray ((0,0), (h-1,w-1)) [read [c] | row <- ls, c <- row]
  where h = length ls
        w = length (head ls)

neighbors8 :: (Int, Int) -> [(Int, Int)]
neighbors8 (x, y) = [(x+dx, y+dy) | dx <- [-1,0,1], dy <- [-1,0,1], (dx, dy) /= (0, 0)]

step :: Grid -> (Grid, Int)
step g = (g'', flashes)
  where
    g' = fmap (+1) g
    (g'', flashes) = flash g' Set.empty (indices g')
    
flash :: Grid -> Set.Set (Int, Int) -> [(Int, Int)] -> (Grid, Int)
flash g flashed [] = (fmap (\v -> if v > 9 then 0 else v) g, Set.size flashed)
flash g flashed (p:ps)
    | p `Set.member` flashed || not (inRange (bounds g) p) = flash g flashed ps
    | g ! p > 9 = let ns = neighbors8 p
                      g' = g // [(n, g ! n + 1) | n <- ns, inRange (bounds g) n]
                  in flash g' (Set.insert p flashed) (ns ++ ps)
    | otherwise = flash g flashed ps

simulate :: Int -> Grid -> Int
simulate 0 g = 0
simulate n g = flashes + simulate (n-1) g'
  where (g', flashes) = step g

part1 :: Int
part1 = simulate 100 input

findSync :: Int -> Grid -> Int
findSync n g = if flashes == length (indices g) then n else findSync (n+1) g'
  where (g', flashes) = step g

part2 :: Int
part2 = findSync 1 input
