import InputUtils (readInput)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Set as Set

input :: String
input = unsafePerformIO $ readInput 2016 1

data Dir = N | E | S | W deriving (Eq, Ord, Show)
type Pos = (Int, Int)

parseInput :: String -> [(Char, Int)]
parseInput str = map parse $ words $ filter (/= ',') str
  where parse (d:ds) = (d, read ds)

turnLeft :: Dir -> Dir
turnLeft N = W
turnLeft W = S
turnLeft S = E
turnLeft E = N

turnRight :: Dir -> Dir
turnRight N = E
turnRight E = S
turnRight S = W
turnRight W = N

move :: Dir -> Pos -> Pos
move N (x, y) = (x, y + 1)
move E (x, y) = (x + 1, y)
move S (x, y) = (x, y - 1)
move W (x, y) = (x - 1, y)

manhattan :: Pos -> Int
manhattan (x, y) = abs x + abs y

walk :: [(Char, Int)] -> Pos
walk instructions = go N (0, 0) instructions
  where
    go _ pos [] = pos
    go dir pos ((turn, steps):rest) =
      let newDir = if turn == 'L' then turnLeft dir else turnRight dir
          newPos = iterate (move newDir) pos !! steps
      in go newDir newPos rest

walkUntilRepeat :: [(Char, Int)] -> Int
walkUntilRepeat instructions = go N (0, 0) (Set.singleton (0, 0)) instructions
  where
    go _ pos _ [] = error "No repeat found"
    go dir pos visited ((turn, steps):rest) =
      let newDir = if turn == 'L' then turnLeft dir else turnRight dir
          positions = take steps $ tail $ iterate (move newDir) pos
          checkPos [] = go newDir (last positions) (Set.union visited (Set.fromList positions)) rest
          checkPos (p:ps) = if Set.member p visited then manhattan p else checkPos ps
      in checkPos positions

part1 :: Int
part1 = manhattan $ walk $ parseInput input

part2 :: Int
part2 = walkUntilRepeat $ parseInput input
