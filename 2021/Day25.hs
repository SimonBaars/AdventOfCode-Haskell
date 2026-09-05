import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)
import Data.Array

type Grid = Array (Int, Int) Char

input :: Grid
input = unsafePerformIO $ parseGrid <$> readInputLines 2021 25

parseGrid :: [String] -> Grid
parseGrid ls = listArray ((0,0), (h-1,w-1)) [c | row <- ls, c <- row]
  where h = length ls
        w = length (head ls)

step :: Grid -> Maybe Grid
step grid = if grid == grid'' then Nothing else Just grid''
  where
    ((0,0), (maxY, maxX)) = bounds grid
    
    moveEast = array (bounds grid) 
        [((y,x), newCell y x) | y <- [0..maxY], x <- [0..maxX]]
      where
        newCell y x 
            | grid ! (y, x) == '>' && grid ! (y, (x+1) `mod` (maxX+1)) == '.' = '.'
            | grid ! (y, (x-1) `mod` (maxX+1)) == '>' && grid ! (y, x) == '.' = '>'
            | otherwise = grid ! (y, x)
    
    grid'' = array (bounds grid)
        [((y,x), newCell y x) | y <- [0..maxY], x <- [0..maxX]]
      where
        newCell y x
            | moveEast ! (y, x) == 'v' && moveEast ! ((y+1) `mod` (maxY+1), x) == '.' = '.'
            | moveEast ! ((y-1) `mod` (maxY+1), x) == 'v' && moveEast ! (y, x) == '.' = 'v'
            | otherwise = moveEast ! (y, x)

findSteady :: Grid -> Int
findSteady grid = go 1 grid
  where
    go n g = case step g of
        Nothing -> n
        Just g' -> go (n+1) g'

part1 :: Int
part1 = findSteady input

part2 :: Int
part2 = 0  -- Free star
