import Data.List
import InputUtils (readInputLines)
import System.IO.Unsafe (unsafePerformIO)

input :: [[Bool]]
input = unsafePerformIO $ map parseLine <$> readInputLines 2020 11

parseLine :: String -> [Bool]
parseLine = map (== 'L')

rows :: Int
rows = length input

cols :: Int
cols = length (head input)

part1 :: Int
part1 = (sum . concat) $ fp evolve (replicate rows (replicate cols 0))

evolve :: [[Int]] -> [[Int]]
evolve ints = [[evolveCell (nAdjacent ints x y) (getGridPos input x y) (getGridPos ints x y) | y <- [0..cols-1]] | x <- [0..rows-1]]

evolveCell :: Int -> Bool -> Int -> Int
evolveCell 0 True 0 = 1
evolveCell x True 1 | x >= 4 = 0
evolveCell _ _ x = x

getGridPos :: [[a]] -> Int -> Int -> a
getGridPos ints x y = (ints !! x) !! y

nAdjacent :: [[Int]] -> Int -> Int -> Int
nAdjacent ints i j = sum [getGridPos ints x y | x <- [i-1..i+1], y <- [j-1..j+1], x>=0, y>=0, x<rows, y<cols, not (x == i && y == j)]

-- Part 2: first seat visible in each of 8 directions; threshold 5
part2 :: Int
part2 = (sum . concat) $ fp evolve2 (replicate rows (replicate cols 0))

evolve2 :: [[Int]] -> [[Int]]
evolve2 ints = [[evolveCell2 (nVisible ints x y) (getGridPos input x y) (getGridPos ints x y) | y <- [0..cols-1]] | x <- [0..rows-1]]

evolveCell2 :: Int -> Bool -> Int -> Int
evolveCell2 0 True 0 = 1
evolveCell2 x True 1 | x >= 5 = 0
evolveCell2 _ _ x = x

dirs :: [(Int, Int)]
dirs = [(-1,-1),(-1,0),(-1,1),(0,-1),(0,1),(1,-1),(1,0),(1,1)]

nVisible :: [[Int]] -> Int -> Int -> Int
nVisible ints i j = sum [look ints i j dx dy | (dx,dy) <- dirs]

look :: [[Int]] -> Int -> Int -> Int -> Int -> Int
look ints i j dx dy = go (i+dx) (j+dy)
  where
    go x y
      | x < 0 || y < 0 || x >= rows || y >= cols = 0
      | not (getGridPos input x y) = go (x+dx) (y+dy)  -- floor, keep looking
      | otherwise = getGridPos ints x y                -- seat found

fp :: Eq a => (a -> a) -> a -> a
fp f = until (\ x -> x == f x) f
